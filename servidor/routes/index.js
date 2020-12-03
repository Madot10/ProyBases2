const express = require("express");
const router = express.Router();

const { SimulacionCont }= require('../controllers/SimulacionCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var sim = new SimulacionCont;

//Procedimientos y funciones
router.get('/procedure', sim.getProcedure);
//Alistar Productores
router.get('/function', sim.getFunction);

//Probando que sí esté conectado a la BD
router.get('/clima', sim.getClima);


module.exports = router;