-- NCRRA pilot database ownership. The bootstrap secret is injected only on the target host and rotated into separate service credentials before member onboarding.
\getenv keycloak_password KEYCLOAK_DB_PASSWORD
\getenv membership_password MEMBERSHIP_DB_PASSWORD
\getenv ticketing_password TICKETING_DB_PASSWORD
\getenv billing_password BILLING_DB_PASSWORD
CREATE USER keycloak WITH PASSWORD :'keycloak_password';
CREATE USER membership_app WITH PASSWORD :'membership_password';
CREATE USER ticketing_app WITH PASSWORD :'ticketing_password';
CREATE USER billing_app WITH PASSWORD :'billing_password';

CREATE DATABASE keycloak OWNER keycloak;
CREATE DATABASE membership OWNER membership_app;
CREATE DATABASE ticketing OWNER ticketing_app;
CREATE DATABASE billing OWNER billing_app;

REVOKE ALL ON DATABASE membership FROM PUBLIC;
REVOKE ALL ON DATABASE ticketing FROM PUBLIC;
REVOKE ALL ON DATABASE billing FROM PUBLIC;
