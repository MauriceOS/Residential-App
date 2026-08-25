// NCRRA ticketing tenant context: server-derived claim is bound to the same transaction used for RLS-protected data access.
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Ncrra.Ticketing.Api.Persistence;

namespace Ncrra.Ticketing.Api.Security;

public sealed class TenantSessionScope(TicketingDbContext database)
{
    public async Task<IDbContextTransaction> BeginAsync(ClaimsPrincipal principal, CancellationToken cancellationToken)
    {
        var rawTenantId = principal.FindFirstValue("tenant_id") ?? throw new UnauthorizedAccessException("Tenant context is required.");
        if (!Guid.TryParse(rawTenantId, out var tenantId)) throw new UnauthorizedAccessException("Tenant context is invalid.");
        var transaction = await database.Database.BeginTransactionAsync(cancellationToken);
        await database.Database.ExecuteSqlInterpolatedAsync($"SELECT set_config('app.tenant_id', {tenantId.ToString()}, true)", cancellationToken);
        return transaction;
    }
}
