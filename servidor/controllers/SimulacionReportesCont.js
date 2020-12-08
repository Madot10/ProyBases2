"use strict";
const { database } = require("../config/db.config");

class SimulacionReportesCont {
  
  //Simulacion
  getSimulacion(req, res) {
    const { anno_ref } = req.body;

    database.query(`INSERTE LLAMADO DE FUNCIÓN QUE ARRANCA LA SIMULACIÓN $1`, [anno_ref])
      .then(function (data) {
        res.status(200).json(data);
      })
      .catch((e) => console.error(e.stack));
  }



  //Reportes

  //Ranking por año
  getRankingAnno(req, res) {
    const { anno, categoria, order } = req.body;

    database.query(`SELECT * FROM reporte_rank_anno($1::smallint, $2, $3)`, [anno, categoria, order])
      .then(function (data) {
        res.status(200).json(data);
      })
      .catch((e) => console.error(e.stack));
  }


  //Ranking por hora
  getRankingHora(req, res) {
    const { anno, hora, categoria } = req.body;

    database.query(`SELECT * FROM reporte_ranking_hora($1::smallint, $2::smallint, $3)`, [anno, hora, categoria])
      .then(function (data) {
        res.status(200).json(data);
      })
      .catch((e) => console.error(e.stack));
  }


  //Ganadores de Le Mans
  getGanadores(req, res) {
    const { anno } = req.body;

    database.query('SELECT * FROM reporte_ganadores_le_mans($1::smallint)', [anno])
      .then(function (data) {
        res.status(200).json(data);
      })
      .catch((e) => console.error(e.stack));
  }

}

module.exports = { SimulacionReportesCont };