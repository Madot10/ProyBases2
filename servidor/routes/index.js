const express = require("express");
const router = express.Router();

const { SimulacionReportesCont } = require("../controllers/SimulacionReportesCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
var rep = new SimulacionReportesCont();

//Simulación
router.get("/simulacion/:anno_ref/:pista/:clima", rep.getSimulacion);

//Reportes
//Reporte 1 - Ranking por año
router.get("/ranking_anno/:anno/:cat/:tipo", rep.getRankingAnno);
//Reporte 2 - Ranking por hora
router.get("/ranking_hora/:anno/:cat/:hora", rep.getRankingHora);
//Reporte 3 - Ganadores de las 24 Horas de Lemans
router.get("/ganadores/:anno/:cat", rep.getGanadores);

module.exports = router;
