--FUNCIONES AUXILIARES

--FUNC OBTENER POSICION ANTERIOR EQUIPO
--DROP FUNCTION obt_vueltas_equipo_ant (IdTiempo SMALLINT, IdEquipoAct SMALLINT, PuestoAct SMALLINT);
--EJ: SELECT obt_vueltas_equipo_ant(1::smallint, 201::smallint, 1::SMALLINT)
CREATE OR REPLACE FUNCTION obt_vueltas_equipo_ant (IdTiempo SMALLINT, IdEquipoAct SMALLINT, PuestoAct SMALLINT)
    RETURNS NUMERIC (3) LANGUAGE plpgsql AS $$
    DECLARE
        ax_vuelta NUMERIC(3) := 0;
    BEGIN
        SELECT ant_parti.nro_vueltas_carrera_total VueltasAnt INTO ax_vuelta FROM ft_participacion parti
            INNER JOIN ft_participacion ant_parti ON parti.id_dim_tiempo = ant_parti.id_dim_tiempo and parti.puesto_final_carrera = (ant_parti.puesto_final_carrera - 1)
            WHERE parti.id_dim_tiempo = IdTiempo AND parti.id_dim_equipo = IdEquipoAct  AND parti.puesto_final_carrera <> 0 AND parti.puesto_final_carrera = PuestoAct
        GROUP BY  VueltasAnt;


        --Retornamos
        RETURN ax_vuelta;
    END;
$$;

-- OBTENER EVENTO ID SEGUN FECHA
-- Ej: select obt_evento_id(2020);
CREATE OR REPLACE FUNCTION obt_evento_id(anno_ref NUMERIC(4))
    RETURNS SMALLINT LANGUAGE plpgsql AS $$
    declare
        id_obt SMALLINT;
    begin
        SELECT t.id_tiempo INTO id_obt FROM dim_tiempo t  WHERE t.anno = anno_ref;
        RETURN id_obt;
    end;
$$;

--REPORTES

-- REPORTE 4
-- EJ: SELECT * FROM reporte_rank_nro_equipo(1::SMALLINT, 2000)
CREATE OR REPLACE FUNCTION reporte_rank_nro_equipo (n_equipo NUMERIC(3) DEFAULT NULL, anno_ref NUMERIC(4) DEFAULT NULL)
    RETURNS TABLE (
        anno NUMERIC(4),
        NombreEquipo varchar(35),
        NroEquipo NUMERIC(3),
        PaisEquipo VARCHAR(56),
        imgBanderaEquipo TEXT,
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT,
        imgPiloto TEXT,
        NombreVehiculo VARCHAR(30),
        ModeloMotor VARCHAR(30),
        cilindros VARCHAR(3),
        cc NUMERIC(4),
        categoria CHAR(7),
        imgVehiculo TEXT,
        PuestoEnsayo NUMERIC(3),
        MejorVueltaEnsayo TIME,
        VelMediaEnsayo NUMERIC(5,2),
        PuestoCarrera NUMERIC(3),
        NroVueltasCarrera NUMERIC(3),
        DistRecorrida NUMERIC(8),
        VelMediaCarrera NUMERIC(5,2),
        MejorVueltaCarrera TIME,
        DifVueltas NUMERIC(3)
    ) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        end if;

        RETURN QUERY SELECT t.anno, eq.nombre NombreEquipo, parti.nro_equipo, eq.nombre_pais PaisEquipo, eq.img_bandera BanderaEquipo,
            pilot.nombre || ' ' || pilot.apellido NombrePiloto, pilot.gentilicio, pilot.img_bandera BanderaPiloto, pilot.img_piloto,
            veh.modelo ModeloVeh, veh.modelo_motor, veh.cilindros, veh.cc, veh.categoria, veh.img_vehiculo,
            parti.puesto_final_ensayo, parti.tiempo_mejor_vuelta_ensayo, parti.velocidad_media_ensayo,
            parti.puesto_final_carrera, parti.nro_vueltas_carrera_total, (parti.nro_vueltas_carrera_total * parti.total_km_pista) DistRecorrida, parti.velocidad_media_carrera, parti.tiempo_mejor_vuelta_carrera,
            CASE WHEN (parti.nro_vueltas_carrera_total - obt_vueltas_equipo_ant(parti.id_dim_tiempo, parti.id_dim_equipo, parti.puesto_final_carrera::smallint))=0 OR (parti.nro_vueltas_carrera_total - obt_vueltas_equipo_ant(parti.id_dim_tiempo, parti.id_dim_equipo, parti.puesto_final_carrera::smallint)) IS NULL THEN 1 ELSE (parti.nro_vueltas_carrera_total - obt_vueltas_equipo_ant(parti.id_dim_tiempo, parti.id_dim_equipo, parti.puesto_final_carrera::smallint)) END DiffVueltas
        FROM ft_participacion parti
            INNER JOIN dim_equipo eq ON parti.id_dim_equipo = eq.id_equipo
            INNER JOIN dim_piloto pilot ON parti.id_dim_piloto = pilot.id_piloto
            INNER JOIN dim_vehiculo veh ON parti.id_dim_vehiculo = veh.id_vehiculo
            INNER JOIN dim_tiempo t ON parti.id_dim_tiempo = t.id_tiempo
        WHERE (anno_ref IS NULL OR parti.id_dim_tiempo = id_evnt) AND parti.nro_equipo = n_equipo;
    END;
$$;



