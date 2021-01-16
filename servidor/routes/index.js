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

//Parametros
//Obtener annos
router.get("/param/annos", rep.getAnnoParam);
//Obtener nro team
router.get("/param/nro_equipo", rep.getNroEquipoParam);
//Obtener pilotos
router.get("/param/pilotos", rep.getPilotosParam);
//Obtener pilotos mujeres
router.get("/param/pilotos-fem", rep.getPilotosMujeresParam);

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
//Reporte 7 - Piloto más joven
router.get("/piloto_joven/:anno", rep.getPilotoJoven);
//Reporte 8 - Piloto más veterano
router.get("/piloto_veterano/:anno", rep.getPilotoVeterano);
//Reporte 9 - Pilotos con mayores participaciones
router.get("/piloto_mayores_part", rep.getPilotosMayoresPart);
//Reporte 10 - Ganador en su primera participacion
router.get("/ganador_primer_part/:anno", rep.getGanadorPrimeraPart);
//Reporte 11 - Velocidades medias mas altas
router.get("/mejores_vel/:ord/:anno", rep.getMejoresVelocidades);
//Reporte 12 - Distancias mas largas recorridas
router.get("/mejores_dist/:cant", rep.getMejoresDistancias);
//Reporte 13 - En el podium, pero nunca en el primer escalón
router.get("/podium", rep.getPodium);
//Reporte 14 - Pilotos que nunca pisaron la línea de meta de 24 horas
router.get("/abandonos", rep.getAbandonos);

//Reporte 15 - Victorias por marca

//Reporte 16 - Mujeres piloto en Le Mans
router.get("/mujeres_piloto/:anno", rep.getMujeresPiloto);

module.exports = router;
