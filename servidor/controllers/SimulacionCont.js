"use strict";
const { database } = require("../config/db.config");

class SimulacionCont {
  
  //Prueba de llamado de procedimientos para la simulación
  getProcedure(req, res) {
    database.query('call generar_clima($1,$2)',[2,'ll'])
      .then(function() {
        res.status(200).json({
          message: "Clima generado con éxito",
        });
      })
      .catch((e) => console.error(e.stack));
  }

  //Revisar las dos formas 
  //Prueba de llamado de funciones para reportes
  getFunction(req, res) {
    database.func('estimar_temp_promedio_hora', ['n','ll'])
    //database.any('select estimar_temp_promedio_hora($1,$2)',['n','ll'])
      .then(function (data) {
        res.status(200).json({ Prueba: data });
      })
      .catch((e) => console.error(e.stack));
  }

  //Prueba para ver si está conectado a la BD
  getClima(req, res) {
    database.query('select * from sucesos')
      .then(function (data) {
        res.status(200).json({ Prueba: data });
      })
      .catch((e) => console.error(e.stack));
  }

}

module.exports = { SimulacionCont };