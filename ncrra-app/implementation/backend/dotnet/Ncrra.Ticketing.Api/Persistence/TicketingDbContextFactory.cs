using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Ncrra.Ticketing.Api.Persistence;

public sealed class TicketingDbContextFactory : IDesignTimeDbContextFactory<TicketingDbContext>
{
    public TicketingDbContext CreateDbContext(string[] args)
    {
        var connection = Environment.GetEnvironmentVariable("TICKETING_MIGRATIONS_CONNECTION")
            ?? throw new InvalidOperationException("Set TICKETING_MIGRATIONS_CONNECTION for migration generation or update.");
        return new TicketingDbContext(new DbContextOptionsBuilder<TicketingDbContext>().UseNpgsql(connection).Options);
    }
}
