"use strict";
const { database } = require("../config/db.config");

function verificar_int(anno) {
    if (parseInt(anno, 10) === 0) {
        return null;
    }
    return anno;
}

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

    //Parametros
    //Obtener annos
    getAnnoParam(req, res) {
        database
            .query(`SELECT * FROM obt_annos_db()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //Obtener nros equipos
    getNroEquipoParam(req, res) {
        database
            .query(`SELECT * FROM obt_nro_equipos_db()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //Obtener pilotos
    getPilotosParam(req, res) {
        database
            .query(`SELECT * FROM obt_pilotos_db()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //Obtener pilotos mujeres
    getPilotosMujeresParam(req, res) {
        database
            .query(`SELECT * FROM obt_pilotos_fem_db()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //Obtener fabricantes de auto
    getFabricantesAuto(req, res) {
        database
            .query(`SELECT * FROM obt_fabricantes_auto()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //Obtener modelos de autos
    getModelosAuto(req, res) {
        database
            .query(`SELECT * FROM obt_modelos_auto()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
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
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
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
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
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
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //4. Ranking por numero de equipo
    getRankingEquipo(req, res) {
        var anno = req.params.anno;
        anno = verificar_int(anno);
        var num_equipo = req.params.num_equipo;
        num_equipo = verificar_int(num_equipo);

        database
            .query(`SELECT * FROM reporte_rank_nro_equipo($1::SMALLINT, $2::SMALLINT)`, [
                num_equipo,
                anno,
            ])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //5.1. Logros del piloto - Datos del piloto
    getLogrosPiloto(req, res) {
        const id_pilot = req.params.id_pilot;

        database
            .query(`SELECT * FROM reporte_logros_piloto($1::smallint)`, [id_pilot])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //5.2. Logros del piloto - Datos de las participaciones
    getDatosParticipacion(req, res) {
        const id_pilot = req.params.id_pilot;

        database
            .query(`SELECT * FROM reporte_datos_participacion($1::smallint)`, [id_pilot])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //6. Participacion segun marca (fabricante_auto) y modelo de Veh
    getParticipacionMarcaModelo(req, res) {
        var marca = req.params.marca;
        var modelo = req.params.modelo;

        if (String(marca) == "0") {
            marca = null;
        }
        if (String(modelo) == "0") {
            modelo = null;
        }

        database
            .query(`SELECT * FROM reporte_participaciones_marcas_modelos($1,$2)`, [marca, modelo])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //7. Piloto más joven
    getPilotoJoven(req, res) {
        var anno = req.params.anno;
        anno = verificar_int(anno);
        database
            .query(`SELECT * FROM reporte_piloto_joven($1::smallint)`, [anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //8. Piloto más veterano
    getPilotoVeterano(req, res) {
        var anno = req.params.anno;
        anno = verificar_int(anno);

        database
            .query(` SELECT * FROM reporte_piloto_mayor($1::smallint)`, [anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //9. Pilotos con mayores participaciones
    getPilotosMayoresPart(req, res) {
        database
            .query(`SELECT * FROM  reporte_pilotos_mayor_participaciones()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //10. Ganador en su primera participacion
    getGanadorPrimeraPart(req, res) {
        var anno = req.params.anno;
        anno = verificar_int(anno);

        database
            .query(`SELECT * FROM reporte_ganador_primera_participacion($1::smallint)`, [anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //11. Velocidades medias mas altas
    getMejoresVelocidades(req, res) {
        const ord = req.params.ord;
        var anno = req.params.anno;
        anno = verificar_int(anno);

        database
            .query(`SELECT * FROM reporte_top_vel_media($1, $2::smallint)`, [ord, anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //12. Distancias mas largas recorridas
    getMejoresDistancias(req, res) {
        const cant = req.params.cant;
        console.log("cant", cant);
        database
            .query(`SELECT * FROM reporte_distancias_mas_largas($1)`, [cant])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //13. En el podium, pero nunca en el primer escalón
    getPodium(req, res) {
        database
            .query(`SELECT * FROM reporte_pilotos_podiums()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //14. En el podium, pero nunca en el primer escalón
    getAbandonos(req, res) {
        database
            .query(`SELECT * FROM reporte_pilotos_nunca_meta()`)
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }

    //15. Victorias por marca

    //16. Mujeres piloto en Le Mans
    getMujeresPiloto(req, res) {
        var anno = req.params.anno;
        anno = verificar_int(anno);

        database
            .query(`SELECT * FROM reporte_mujeres_pilotos($1::smallint)`, [anno])
            .then(function (data) {
                res.status(200).json(data.rows);
            })
            .catch((e) => {
                res.status(500).json(e);
                console.error(e.stack);
            });
    }
}

module.exports = { SimulacionReportesCont };
