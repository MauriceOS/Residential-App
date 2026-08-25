// Membership owns profile, membership lifecycle and consent revisions. It does not store ticket or payment workflow state.
using Microsoft.EntityFrameworkCore;

namespace Ncrra.Membership.Api.Persistence;

public sealed class MembershipDbContext(DbContextOptions<MembershipDbContext> options) : DbContext(options)
{
    public DbSet<MemberProfile> MemberProfiles => Set<MemberProfile>();
    public DbSet<ConsentRevision> ConsentRevisions => Set<ConsentRevision>();
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<MemberProfile>(entity =>
        {
            entity.ToTable("member_profiles");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.DisplayName).HasMaxLength(180).IsRequired();
            entity.Property(item => item.Email).HasMaxLength(320).IsRequired();
            entity.Property(item => item.Phone).HasMaxLength(40).IsRequired();
            entity.Property(item => item.Area).HasMaxLength(120);
            entity.Property(item => item.MembershipStatus).HasMaxLength(40).IsRequired();
            entity.HasIndex(item => new { item.TenantId, item.SubjectId }).IsUnique();
        });
        builder.Entity<ConsentRevision>(entity =>
        {
            entity.ToTable("consent_revisions");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Purpose).HasMaxLength(120).IsRequired();
            entity.Property(item => item.NoticeVersion).HasMaxLength(80).IsRequired();
            entity.HasIndex(item => new { item.TenantId, item.MemberProfileId, item.Purpose, item.RecordedAt });
        });
        builder.Entity<OutboxMessage>(entity =>
        {
            entity.ToTable("outbox_messages");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.EventType).HasMaxLength(120).IsRequired();
            entity.Property(item => item.Payload).HasColumnType("jsonb").IsRequired();
        });
    }
}

public sealed class MemberProfile
{
    public Guid Id { get; init; }
    public Guid TenantId { get; init; }
    // OIDC subject only; the mobile app never selects a tenant identifier.
    public required string SubjectId { get; init; }
    public required string DisplayName { get; set; }
    public required string Email { get; set; }
    public required string Phone { get; set; }
    public string? Area { get; set; }
    public required string MembershipStatus { get; set; }
    public DateTimeOffset CreatedAt { get; init; }
    public DateTimeOffset UpdatedAt { get; set; }
}

public sealed class ConsentRevision
{
    public Guid Id { get; init; }
    public Guid TenantId { get; init; }
    public Guid MemberProfileId { get; init; }
    public required string Purpose { get; init; }
    public required string NoticeVersion { get; init; }
    public bool Granted { get; init; }
    public DateTimeOffset RecordedAt { get; init; }
}

public sealed class OutboxMessage
{
    public Guid Id { get; init; }
    public Guid TenantId { get; init; }
    public required string EventType { get; init; }
    public required string Payload { get; init; }
    public DateTimeOffset OccurredAt { get; init; }
    public DateTimeOffset? PublishedAt { get; set; }
}
