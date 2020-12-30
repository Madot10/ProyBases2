const express = require("express");
const router = express.Router();

const { SimulacionReportesCont } = require("../controllers/SimulacionReportesCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
var rep = new SimulacionReportesCont();

//Simulación
router.get("/simulacion/:anno_ref/:pista/:clima", rep.getSimulacion);
//Clima
router.get("/clima/:anno", rep.getClima);
//Pilotos
router.get("/pilotos", rep.getPilotos);

//Reportes
//Reporte 1 - Ranking por año
router.get("/ranking_anno/:anno/:cat/:tipo", rep.getRankingAnno);
//Reporte 2 - Ranking por hora
router.get("/ranking_hora/:anno/:cat/:hora", rep.getRankingHora);
//Reporte 3 - Ganadores de las 24 Horas de Lemans
router.get("/ganadores/:anno/:cat", rep.getGanadores);
//Reporte 4 - Ranking por Numero de equipo
router.get("/ranking_equipo/:anno/:num_equipo", rep.getRankingEquipo);
//Reporte 5.1 - Logros del piloto - Datos del piloto
router.get("/logros_datos/:id_pilot", rep.getLogrosPiloto);
//Reporte 5.2 - Logros del piloto - Datos de las participaciones
router.get("/logros_part/:id_pilot", rep.getDatosParticipacion);
//Reporte 6 - Participacion segun marca (fabricante_auto) y modelo de Veh
router.get("/part_marca_modelo/:marca/:modelo", rep.getParticipacionMarcaModelo);

module.exports = router;
