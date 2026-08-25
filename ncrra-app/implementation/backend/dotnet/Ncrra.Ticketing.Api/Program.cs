// NCRRA Ticketing service: tenant scope is read from verified OIDC claims; it is never accepted as a client query parameter.
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Ncrra.Ticketing.Api.Persistence;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

var builder = WebApplication.CreateBuilder(args);
var authority = builder.Configuration["Authentication:Authority"] ?? throw new InvalidOperationException("Authentication:Authority must be configured.");
var audience = builder.Configuration["Authentication:Audience"] ?? throw new InvalidOperationException("Authentication:Audience must be configured.");
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>
{
    options.Authority = authority;
    options.Audience = audience;
    options.RequireHttpsMetadata = !builder.Environment.IsDevelopment();
    options.MapInboundClaims = false;
});
builder.Services.AddAuthorization(options => options.AddPolicy("member", policy => policy.RequireAuthenticatedUser().RequireClaim("tenant_id").RequireClaim("ncrra_role", "member", "association_admin", "platform_support")));
builder.Services.AddOpenTelemetry().ConfigureResource(resource => resource.AddService("ncrra-ticketing-api")).WithTracing(tracing => tracing.AddAspNetCoreInstrumentation().AddHttpClientInstrumentation().AddOtlpExporter());
var ticketingConnection = builder.Configuration.GetConnectionString("Ticketing") ?? throw new InvalidOperationException("ConnectionStrings:Ticketing must be configured at runtime.");
builder.Services.AddDbContext<TicketingDbContext>(options => options.UseNpgsql(ticketingConnection));
builder.Services.AddScoped<Ncrra.Ticketing.Api.Security.TenantSessionScope>();

var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();
app.MapGet("/healthz", () => Results.Ok(new { status = "ok", service = "ticketing" })).AllowAnonymous();

app.MapGet("/api/v1/tickets", (ClaimsPrincipal actor, string? q, string? status, string? service, string? sort) =>
{
    var tenantId = actor.FindFirstValue("tenant_id");
    var memberId = actor.FindFirstValue("sub");
    if (string.IsNullOrWhiteSpace(tenantId) || string.IsNullOrWhiteSpace(memberId)) return Results.Forbid();

    // Repository query must apply tenantId and memberId before optional user filters. This sample contract response is intentionally empty until the Ticketing database is wired.
    return Results.Ok(new { items = Array.Empty<object>(), filters = new { q, status, service, sort }, scope = "server-derived" });
}).RequireAuthorization("member");

app.Run();
