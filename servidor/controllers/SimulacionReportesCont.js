"use strict";
const { database } = require("../config/db.config");

class SimulacionReportesCont {
    //Simulacion
    getSimulacion(req, res) {
        const pista = req.params.pista;
        const anno_ref = req.params.anno_ref;
        const clima = req.params.clima;

        database
            .query(
                `call simulacion_le_mans( $1::SMALLINT, '10/12/2020'::TIMESTAMP, $2::SMALLINT, $3)`,
                [pista, anno_ref, clima]
            )
            .then(function (data) {
                database
                    .query(`SELECT * FROM reporte_rank_anno(2020::smallint, NULL, 'car')`)
                    .then(function (data) {
                        res.status(200).json(data.rows);
                    })
                    .catch((e) => console.error(e.stack));
            })
            .catch((e) => console.error(e.stack));
    }

    getClima(req, res) {
        const anno = req.params.anno;
        database
            .query(`SELECT * FROM obtener_metereologia_evento($1::smallint)`, [anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    getPilotos(req, res) {
        database
            .query(`select * from pilotos();`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //Reportes

    //1. Ranking por año
    getRankingAnno(req, res) {
        const anno = req.params.anno;
        const categoria = req.params.cat || null;
        const order = req.params.tipo;

        database
            .query(`SELECT * FROM reporte_rank_anno($1::smallint, $2, $3)`, [
                anno,
                categoria,
                order,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //2. Ranking por hora
    getRankingHora(req, res) {
        const anno = req.params.anno;
        const categoria = req.params.cat;
        const hora = req.params.hora;

        database
            .query(`SELECT * FROM reporte_ranking_hora($1::smallint, $2::smallint, $3)`, [
                anno,
                hora,
                categoria,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //3. Ganadores de Le Mans
    getGanadores(req, res) {
        const anno = req.params.anno;
        const categoria = req.params.cat;

        database
            .query(`SELECT * FROM reporte_ganadores_le_mans($1::CHAR(7) ,$2::smallint)`, [
                categoria,
                anno,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //4. Ranking por numero de equipo
    getRankingEquipo(req, res) {
        var anno = req.params.anno;
        var num_equipo = req.params.num_equipo;
        
        if(parseInt(anno,10) === 0){
            anno = null;
        }
        if(parseInt(num_equipo,10) === 0){
            num_equipo = null;
        }

        database
            .query(`SELECT * FROM reporte_rank_nro_equipo($1::SMALLINT, $2::SMALLINT)`, [
                num_equipo,
                anno,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //5.1. Logros del piloto - Datos del piloto
    getLogrosPiloto(req, res) {
        const id_pilot = req.params.id_pilot;

        database
            .query(`SELECT * FROM reporte_logros_piloto($1::smallint)`, [
                id_pilot
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    //5.2. Logros del piloto - Datos de las participaciones
    getDatosParticipacion(req, res) {
        const id_pilot = req.params.id_pilot;

        database
            .query(`SELECT * FROM reporte_datos_participacion($1::smallint)`, [
                id_pilot
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

    
    //6. Participacion segun marca (fabricante_auto) y modelo de Veh
    getParticipacionMarcaModelo(req, res) {
        var marca = req.params.marca;
        var modelo = req.params.modelo;
        
        if(String(marca) == '0'){
            marca = null;
        }
        if(String(modelo) == '0'){
            modelo = null;
        }

        database
            .query(`SELECT * FROM reporte_participaciones_marcas_modelos($1,$2)`, [
                marca,
                modelo,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => console.error(e.stack));
    }

}

module.exports = { SimulacionReportesCont };
