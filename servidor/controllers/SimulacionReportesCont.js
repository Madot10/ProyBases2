"use strict";
const { database } = require("../config/db.config");

class SimulacionReportesCont {
    //Simulacion
    getSimulacion(req, res) {
        //const { anno_ref } = req.body;

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

    //Reportes

    //Ranking por año
    getRankingAnno(req, res) {
        //const { anno, categoria, order } = req.body;
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

    //Ranking por hora
    getRankingHora(req, res) {
        //const { anno, hora, categoria } = req.body;
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

    //Ganadores de Le Mans
    getGanadores(req, res) {
        //const { anno } = req.body;
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
}

module.exports = { SimulacionReportesCont };
