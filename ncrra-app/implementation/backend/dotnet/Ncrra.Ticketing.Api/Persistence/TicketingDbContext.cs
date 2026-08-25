// Ticketing owns ticket state, history and outbox records. All query paths must require a server-derived tenant predicate.
using Microsoft.EntityFrameworkCore;

namespace Ncrra.Ticketing.Api.Persistence;

public sealed class TicketingDbContext(DbContextOptions<TicketingDbContext> options) : DbContext(options)
{
    public DbSet<Ticket> Tickets => Set<Ticket>();
    public DbSet<TicketStatusHistory> TicketStatusHistory => Set<TicketStatusHistory>();
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<Ticket>(entity =>
        {
            entity.ToTable("tickets");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.PublicReference).HasMaxLength(32).IsRequired();
            entity.Property(item => item.Title).HasMaxLength(180).IsRequired();
            entity.Property(item => item.Service).HasMaxLength(40).IsRequired();
            entity.Property(item => item.Status).HasMaxLength(40).IsRequired();
            entity.Property(item => item.ConnectionReferenceToken).HasMaxLength(180);
            entity.HasIndex(item => new { item.TenantId, item.MemberId, item.UpdatedAt });
            entity.HasIndex(item => new { item.TenantId, item.PublicReference }).IsUnique();
        });
        builder.Entity<TicketStatusHistory>(entity =>
        {
            entity.ToTable("ticket_status_history");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Status).HasMaxLength(40).IsRequired();
            entity.Property(item => item.Note).HasMaxLength(1_000);
            entity.HasIndex(item => new { item.TenantId, item.TicketId, item.OccurredAt });
        });
        builder.Entity<OutboxMessage>(entity =>
        {
            entity.ToTable("outbox_messages");
            entity.HasKey(item => item.Id);
            entity.Property(item => item.EventType).HasMaxLength(120).IsRequired();
            entity.Property(item => item.Payload).HasColumnType("jsonb").IsRequired();
            entity.HasIndex(item => new { item.OccurredAt, item.PublishedAt });
        });
    }
}

public sealed class Ticket
{
    public Guid Id { get; init; }
    public Guid TenantId { get; init; }
    public Guid MemberId { get; init; }
    public required string PublicReference { get; init; }
    public required string Title { get; init; }
    public required string Service { get; init; }
    public required string Status { get; set; }
    // Stores a vault/token reference rather than a raw provider account, meter number or identifier.
    public string? ConnectionReferenceToken { get; init; }
    public DateTimeOffset CreatedAt { get; init; }
    public DateTimeOffset UpdatedAt { get; set; }
}

public sealed class TicketStatusHistory
{
    public Guid Id { get; init; }
    public Guid TenantId { get; init; }
    public Guid TicketId { get; init; }
    public required string Status { get; init; }
    public string? Note { get; init; }
    public Guid? ActorId { get; init; }
    public DateTimeOffset OccurredAt { get; init; }
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
