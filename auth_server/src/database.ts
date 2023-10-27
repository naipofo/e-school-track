import { Kysely, PostgresDialect } from "kysely";
import { Pool } from "pg";
import PublicSchema from "./schemas/public/PublicSchema";

const dialect = new PostgresDialect({
  pool: new Pool({
    database: "postgres",
    host: "localhost",
    user: "postgres",
    password: "postgrespassword",
    port: 5432,
    max: 10,
  }),
});

export const db = new Kysely<PublicSchema>({
  dialect,
});
