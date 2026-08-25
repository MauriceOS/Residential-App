# NCRRA local toolchain baseline

The local implementation workspace installed Flutter 3.47.1 with Dart 3.13.1 from the Flutter stable channel, .NET SDK 10.0.111 from Ubuntu 24.04’s supported package feed, Go 1.27.0 from the official Go distribution, and Docker Engine 29.7.2 with Docker Compose v5.5.0 from Docker’s Ubuntu repository. Flutter analysis and source builds are run locally; application and infrastructure dependencies are still non-production unless configured through the guarded local workflow.

The .NET services use OpenTelemetry 1.18.0 and Npgsql Entity Framework Core PostgreSQL 10.0.3 after updating away from the vulnerable OpenTelemetry 1.10.0 packages.

## Sources

1. [Flutter manual installation guide](https://docs.flutter.dev/install/manual)
2. [.NET installation on Ubuntu](https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install)
3. [Docker Engine installation on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
4. [OpenTelemetry.Extensions.Hosting 1.18.0](https://www.nuget.org/packages/OpenTelemetry.Extensions.Hosting/)
5. [Npgsql.EntityFrameworkCore.PostgreSQL 10.0.3](https://www.nuget.org/packages/Npgsql.EntityFrameworkCore.PostgreSQL/)
6. [Flutter AppAuth 12.0.2](https://pub.dev/packages/flutter_appauth)
7. [Flutter Secure Storage 11.0.0](https://pub.dev/packages/flutter_secure_storage)
