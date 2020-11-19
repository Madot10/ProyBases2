const { Pool } = require("pg");

//Config de prueba => Cambiar
const db = {
    user: "postgres",
    host: "localhost",
    database: "sistema_le_vams",
    password: "12345",
    port: 5432,
    multipleStatements: true,
};
const database = new Pool(db);

module.exports = { database };
