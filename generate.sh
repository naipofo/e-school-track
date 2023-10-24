gq http://localhost:8080/v1/graphql -H 'x-hasura-admin-secret: myadminsecretkey' --introspect > school_track_front/lib/graphql/schema.graphql

~/.cargo/bin/diesel print-schema --database-url postgres://postgres:postgrespassword@localhost:5432/postgres > rs_database_models/src/schema.rs