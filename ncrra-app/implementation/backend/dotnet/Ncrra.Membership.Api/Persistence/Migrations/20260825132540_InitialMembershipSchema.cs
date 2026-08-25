using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ncrra.Membership.Api.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialMembershipSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "consent_revisions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    MemberProfileId = table.Column<Guid>(type: "uuid", nullable: false),
                    Purpose = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false),
                    NoticeVersion = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                    Granted = table.Column<bool>(type: "boolean", nullable: false),
                    RecordedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_consent_revisions", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "member_profiles",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    SubjectId = table.Column<string>(type: "text", nullable: false),
                    DisplayName = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    Email = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    Phone = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    Area = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    MembershipStatus = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_member_profiles", x => x.Id);
                });

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

            migrationBuilder.CreateIndex(
                name: "IX_consent_revisions_TenantId_MemberProfileId_Purpose_Recorded~",
                table: "consent_revisions",
                columns: new[] { "TenantId", "MemberProfileId", "Purpose", "RecordedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_member_profiles_TenantId_SubjectId",
                table: "member_profiles",
                columns: new[] { "TenantId", "SubjectId" },
                unique: true);

            migrationBuilder.Sql("""
                ALTER TABLE member_profiles ENABLE ROW LEVEL SECURITY;
                ALTER TABLE member_profiles FORCE ROW LEVEL SECURITY;
                CREATE POLICY member_profile_tenant_isolation ON member_profiles
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);

                ALTER TABLE consent_revisions ENABLE ROW LEVEL SECURITY;
                ALTER TABLE consent_revisions FORCE ROW LEVEL SECURITY;
                CREATE POLICY consent_tenant_isolation ON consent_revisions
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);

                ALTER TABLE outbox_messages ENABLE ROW LEVEL SECURITY;
                ALTER TABLE outbox_messages FORCE ROW LEVEL SECURITY;
                CREATE POLICY membership_outbox_tenant_isolation ON outbox_messages
                  USING ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid)
                  WITH CHECK ("TenantId" = NULLIF(current_setting('app.tenant_id', true), '')::uuid);
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "consent_revisions");

            migrationBuilder.DropTable(
                name: "member_profiles");

            migrationBuilder.DropTable(
                name: "outbox_messages");
        }
    }
}
