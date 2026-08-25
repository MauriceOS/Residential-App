using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ncrra.Ticketing.Api.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialTicketingSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "outbox_messages",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    EventType = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false),
                    Payload = table.Column<string>(type: "jsonb", nullable: false),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    PublishedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_outbox_messages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ticket_status_history",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    TicketId = table.Column<Guid>(type: "uuid", nullable: false),
                    Status = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    Note = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    ActorId = table.Column<Guid>(type: "uuid", nullable: true),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ticket_status_history", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "tickets",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    MemberId = table.Column<Guid>(type: "uuid", nullable: false),
                    PublicReference = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                    Title = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    Service = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    Status = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    ConnectionReferenceToken = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tickets", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_outbox_messages_OccurredAt_PublishedAt",
                table: "outbox_messages",
                columns: new[] { "OccurredAt", "PublishedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_ticket_status_history_TenantId_TicketId_OccurredAt",
                table: "ticket_status_history",
                columns: new[] { "TenantId", "TicketId", "OccurredAt" });

            migrationBuilder.CreateIndex(
                name: "IX_tickets_TenantId_MemberId_UpdatedAt",
                table: "tickets",
                columns: new[] { "TenantId", "MemberId", "UpdatedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_tickets_TenantId_PublicReference",
                table: "tickets",
                columns: new[] { "TenantId", "PublicReference" },
                unique: true);

            migrationBuilder.Sql("""
                ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
                ALTER TABLE tickets FORCE ROW LEVEL SECURITY;
                CREATE POLICY ticket_tenant_isolation ON tickets
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);

                ALTER TABLE ticket_status_history ENABLE ROW LEVEL SECURITY;
                ALTER TABLE ticket_status_history FORCE ROW LEVEL SECURITY;
                CREATE POLICY ticket_history_tenant_isolation ON ticket_status_history
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);

                ALTER TABLE outbox_messages ENABLE ROW LEVEL SECURITY;
                ALTER TABLE outbox_messages FORCE ROW LEVEL SECURITY;
                CREATE POLICY ticket_outbox_tenant_isolation ON outbox_messages
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "outbox_messages");

            migrationBuilder.DropTable(
                name: "ticket_status_history");

            migrationBuilder.DropTable(
                name: "tickets");
        }
    }
}
