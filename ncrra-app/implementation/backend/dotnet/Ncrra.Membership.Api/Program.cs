// NCRRA Membership service: membership profile and consent are service-owned; other services consume projections/events only.
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Ncrra.Membership.Api.Persistence;
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
builder.Services.AddOpenTelemetry().ConfigureResource(resource => resource.AddService("ncrra-membership-api")).WithTracing(tracing => tracing.AddAspNetCoreInstrumentation().AddOtlpExporter());
var membershipConnection = builder.Configuration.GetConnectionString("Membership") ?? throw new InvalidOperationException("ConnectionStrings:Membership must be configured at runtime.");
builder.Services.AddDbContext<MembershipDbContext>(options => options.UseNpgsql(membershipConnection));
builder.Services.AddScoped<Ncrra.Membership.Api.Security.TenantSessionScope>();

var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();
app.MapGet("/healthz", () => Results.Ok(new { status = "ok", service = "membership" })).AllowAnonymous();
app.MapGet("/api/v1/me/membership", (ClaimsPrincipal actor) =>
{
    var tenantId = actor.FindFirstValue("tenant_id");
    var memberId = actor.FindFirstValue("sub");
    if (string.IsNullOrWhiteSpace(tenantId) || string.IsNullOrWhiteSpace(memberId)) return Results.Forbid();
    return Results.Ok(new { memberId, membershipStatus = "active", scope = "server-derived" });
}).RequireAuthorization("member");
app.Run();
