const { makeKyselyHook } = require("kanel-kysely");

module.exports = {
  connection: {
    host: "localhost",
    port: "5432",
    user: "postgres",
    password: "postgrespassword",
    database: "postgres",
  },

  outputPath: "./src/schemas",
  preDeleteOutputFolder: true,
  preRenderHooks: [makeKyselyHook()],
};
