using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Ncrra.Membership.Api.Persistence;

public sealed class MembershipDbContextFactory : IDesignTimeDbContextFactory<MembershipDbContext>
{
    public MembershipDbContext CreateDbContext(string[] args)
    {
        var connection = Environment.GetEnvironmentVariable("MEMBERSHIP_MIGRATIONS_CONNECTION")
            ?? throw new InvalidOperationException("Set MEMBERSHIP_MIGRATIONS_CONNECTION for migration generation or update.");
        return new MembershipDbContext(new DbContextOptionsBuilder<MembershipDbContext>().UseNpgsql(connection).Options);
    }
}
