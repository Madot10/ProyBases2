const { Pool } = require("pg");

//Config de prueba => SuperAdming
/*const db = {
    user: "postgres",
    host: "localhost",
    database: "sistema_le_vams",
    password: "12345",
    port: 5432,
    multipleStatements: true,
};*/
//Config DM
const db = {
    user: "analista3",
    host: "localhost",
    database: "le_vams_dw",
    password: "12345",
    port: 5432,
    multipleStatements: true,
};
const database = new Pool(db);

module.exports = { database };
