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

--Getter de annos en sist para opciones
--SELECT * FROM obt_annos_db();
CREATE OR REPLACE FUNCTION obt_annos_db()
    RETURNS TABLE (
        Anno NUMERIC(4)
                  ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT dt.anno FROM dim_tiempo dt ORDER BY dt.anno;
    END;
$$;

--Getter de nro de equipos en sist para opciones
--SELECT * FROM obt_nro_equipos_db();
CREATE OR REPLACE FUNCTION obt_nro_equipos_db()
    RETURNS TABLE (
        NroEquipo NUMERIC(3)
                  ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT parti.nro_equipo FROM ft_participacion parti GROUP BY nro_equipo ORDER BY nro_equipo;
    END;
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
        WHERE (anno_ref IS NULL OR parti.id_dim_tiempo = id_evnt) AND (n_equipo IS NULL OR parti.nro_equipo = n_equipo);
    END;
$$;



--REPORTE 5 (2 partes)

--LOGROS DE PILOTO
--EJ: SELECT * FROM reporte_logros_piloto(1::smallint)
--DROP FUNCTION  reporte_logros_piloto(id_pilot SMALLINT)
--5.1 DATOS PILOTO
DROP FUNCTION  reporte_logros_piloto(id_pilot SMALLINT)
CREATE OR REPLACE FUNCTION reporte_logros_piloto(id_pilot SMALLINT)
    RETURNS TABLE(
        AnnoPrimeraParticipacion NUMERIC(4),
        CantParticipaciones BIGINT,
        CantPrimerLugar BIGINT,
        CantPodium BIGINT,
        NombrePiloto TEXT,
        FechaNacimiento DATE,
        FechaFallecimiento DATE,
        Edad  DOUBLE PRECISION,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT
                 ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT --Año de primera participacion
               (SELECT MIN(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto =  pilot.id_piloto) AnnoPrimeraParticipacion,
               --Numero total de participaciones
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto) CantParticipaciones,
                --Veces en el 1er puesto
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND parti.puesto_final_carrera = 1) CantPrimerLugar,
               --Veces en el podium (1,2 y3er lugar)
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND( parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3)) CantPodium,
                --Datos
                p.nombre || ' ' || p.apellido NombrePiloto, p.fec_nacimiento, p.fec_fallecimiento,  EXTRACT(YEAR FROM age(p.fec_nacimiento)), p.img_piloto, p.gentilicio, p.img_bandera BanderaPiloto
        FROM ft_participacion parti
            INNER JOIN dim_piloto p on parti.id_dim_piloto = p.id_piloto
        WHERE p.id_piloto = id_pilot LIMIT 1;
    END;
$$;

--5.2 DATOS PARTICIPACIONES
--EJ: SELECT * FROM reporte_datos_participacion(1::smallint);
--Para ser llamado luego del anterior
CREATE OR REPLACE FUNCTION reporte_datos_participacion(id_pilot SMALLINT)
    RETURNS TABLE (
        FechaPartipacion numeric(4),
         NroEquipo NUMERIC(3),
         VehCategoria CHAR(7),
         NombreEquipo VARCHAR(35),
        PaisEquipo VARCHAR(56),
        imgBanderaPais TEXT,
        ImgVehiculo TEXT,
        NombreVehiculo VARCHAR(30),
        NombrePiloto TEXT,
        ImgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT dt.anno, parti.nro_equipo, dv.categoria, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, de.img_bandera ImgBanderaPais, dv.img_vehiculo, dv.modelo ModeloVeh, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.img_piloto, dp.gentilicio, dp.img_bandera ImgBanderaPiloto FROM ft_participacion parti
            INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        WHERE (de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo) IN
              (SELECT de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo FROM ft_participacion parti
                INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
                INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto AND dp.id_piloto = id_pilot);
    END;
$$;

--REPORTE 6
--Participacion segun marca(fabricante_auto) y modelo de Veh
--Ej: SELECT * FROM reporte_participaciones_marcas_modelos('Audi');
--Ej: SELECT * FROM reporte_participaciones_marcas_modelos();
DROP FUNCTION reporte_participaciones_marcas_modelos(marca VARCHAR(30), model VARCHAR(30));
CREATE OR REPLACE FUNCTION reporte_participaciones_marcas_modelos(marca VARCHAR(30) DEFAULT NULL, model VARCHAR(30) DEFAULT NULL)
RETURNS TABLE (
    AnnoParticipacion NUMERIC(4),
    ImgVehiculo TEXT,
    Fabricante VARCHAR(30),
    Modelo VARCHAR(30),
    TipoVeh CHAR(2),
    ModeloMotor VARCHAR(30),
    cilindros VARCHAR(3),
    cc NUMERIC(5),
    categoria CHAR(10),
    FabNeumatico VARCHAR(30),
    NombreEquipo VARCHAR(50),
    NroEquipo NUMERIC(3),
    NombrePiloto TEXT,
    ImgPiloto TEXT,
    Gentilicio VARCHAR(30),
    ImgBanderaPiloto TEXT
  ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT dt.anno, dv.img_vehiculo, dv.fabricante_auto, dv.modelo, dv.tipo, dv.modelo_motor, dv.cilindros, dv.cc, dv.categoria, dv.fabricante_neumatico, de.nombre NombreEquipo, parti.nro_equipo, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.img_piloto, dp.gentilicio, dp.img_bandera imgBanderaPaisPiloto  FROM ft_participacion parti
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
            INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
        WHERE (marca IS NULL OR dv.fabricante_auto like marca) AND (model IS NULL OR dv.modelo like model);
    END;
$$;

--REPORTE 7
--Mas joven
--EJ: SELECT * FROM reporte_piloto_joven(2005::smallint);
--Ej: SELECT * FROM reporte_piloto_joven();
CREATE OR REPLACE FUNCTION reporte_piloto_joven (anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE(
        AnnoParticipacion numeric(4),
        Edad DOUBLE PRECISION,
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgPiloto TEXT,
        ImgBanderaPiloto TEXT
                 ) LANGUAGE  plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT dt.anno, EXTRACT(YEAR FROM age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.gentilicio, dp.img_piloto, dp.img_bandera FROM ft_participacion parti
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        WHERE (age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento), dt.anno) IN (SELECT MIN(age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dt.anno FROM ft_participacion parti
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        GROUP BY anno ORDER BY edad ) AND (anno_ref IS NULL OR dt.anno = anno_ref);
    END;
$$;
 

--REPORTE 8
--Piloto mayor
--EJ: SELECT * FROM reporte_piloto_mayor(2005::smallint);
--EJ: SELECT * FROM reporte_piloto_mayor();
CREATE OR REPLACE FUNCTION reporte_piloto_mayor (anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE(
        AnnoParticipacion numeric(4),
        Edad DOUBLE PRECISION,
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgPiloto TEXT,
        ImgBanderaPiloto TEXT
                 ) LANGUAGE  plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT dt.anno, EXTRACT(YEAR FROM age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.gentilicio, dp.img_piloto, dp.img_bandera FROM ft_participacion parti
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        WHERE (age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento), dt.anno) IN (SELECT MAX(age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dt.anno FROM ft_participacion parti
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        GROUP BY anno ORDER BY edad ) AND (anno_ref IS NULL OR dt.anno = anno_ref);
    END;
$$;

--REPORTE 9
--Pilotos con + parti
--EJ: SELECT * FROM  reporte_pilotos_mayor_participaciones()
--DROP FUNCTION reporte_pilotos_mayor_participaciones();
CREATE OR REPLACE FUNCTION reporte_pilotos_mayor_participaciones()
    RETURNS TABLE (
        NroParticipaciones BIGINT,
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgPiloto TEXT,
        ImgBanderaPiloto TEXT
                  ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT COUNT(*) NroParti, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.gentilicio, dp.img_piloto, dp.img_bandera FROM ft_participacion parti
                INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            GROUP BY  NombrePiloto, dp.gentilicio, img_piloto, img_bandera ORDER BY NroParti DESC LIMIT 10;
    END;
$$;

--REPORTE 10
--GANADOR EN SU PRIMERA PARTICIPACION
--SELECT * FROM reporte_ganador_primera_participacion(2000::smallint);
--SELECT * FROM reporte_ganador_primera_participacion();

DROP FUNCTION reporte_ganador_primera_participacion(anno_ref SMALLINT );
CREATE OR REPLACE FUNCTION reporte_ganador_primera_participacion(anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE (
        Anno NUMERIC(4),
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgBanderaPiloto TEXT,
        ImgPiloto TEXT
        ) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT pp.Anno, pilot.nombre || ' ' || pilot.apellido NombrePiloto, pilot.gentilicio, pilot.img_bandera, pilot.img_piloto FROM dim_piloto pilot
                INNER JOIN (SELECT MIN(dt.anno) Anno, dp.id_piloto FROM ft_participacion parti
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            WHERE parti.puesto_final_carrera = 1 AND (anno_ref IS NULL OR dt.id_tiempo = id_evnt)
                GROUP BY id_piloto) pp ON pp.id_piloto = pilot.id_piloto
                ORDER BY  Anno;
    END;
$$;

--REPORTE 11
--TOP 15
--EJ: SELECT * FROM reporte_top_vel_media('car', 2000::smallint);
--EJ: SELECT * FROM reporte_top_vel_media();
--EJ: SELECT * FROM reporte_top_vel_media('car');
CREATE OR REPLACE FUNCTION reporte_top_vel_media(t_ord CHAR(3) DEFAULT 'car', anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE(
        Anno numeric(4),
        Fabricante VARCHAR(30),
        Modelo VARCHAR(30),
        ImgVehiculo TEXT,
        NombreEquipo VARCHAR(35),
        PaisEquipo VARCHAR(56),
        NroEquipo NUMERIC(3),
        ImgBanderaEquipo TEXT,
        VelMedia NUMERIC(5,2)
                 ) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        IF t_ord = 'eny' THEN
            --Ordenamiento por ensayo
            RETURN QUERY SELECT DISTINCT dt.anno, dv.fabricante_auto, dv.modelo, dv.img_vehiculo, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, parti.nro_equipo, de.img_bandera, parti.velocidad_media_ensayo FROM ft_participacion parti
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
                INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
                WHERE (anno_ref IS NULL OR dt.id_tiempo = id_evnt)
            ORDER BY parti.velocidad_media_ensayo DESC LIMIT 15;
        ELSE
            --Ordenamineto por carrera
            RETURN QUERY SELECT DISTINCT dt.anno, dv.fabricante_auto, dv.modelo, dv.img_vehiculo, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, parti.nro_equipo, de.img_bandera, parti.velocidad_media_carrera FROM ft_participacion parti
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
                INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
                WHERE (anno_ref IS NULL OR dt.id_tiempo = id_evnt)
            ORDER BY parti.velocidad_media_carrera DESC LIMIT 15;
        end if;
    END;
$$;

--REPORTE 12
--Por distancia recorrida
--EJ: SELECT * FROM reporte_distancias_mas_largas();

CREATE OR REPLACE FUNCTION reporte_distancias_mas_largas(limit_num NUMERIC(3) DEFAULT 30)
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
        ORDER BY  DistRecorrida Desc LIMIT limit_num;
    END;
$$;


 --REPORTE 13
--EJ: SELECT * FROM reporte_pilotos_podiums();
--CREATE OR REPLACE FUNCTION reporte_pilotos_podiums()
CREATE OR REPLACE FUNCTION reporte_pilotos_podiums(anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE (
        Anno NUMERIC(4),
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgBanderaPiloto TEXT,
        ImgPiloto TEXT
        ) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT pp.Anno, pilot.nombre || ' ' || pilot.apellido NombrePiloto, pilot.gentilicio, pilot.img_bandera, pilot.img_piloto FROM dim_piloto pilot
                INNER JOIN (SELECT MIN(dt.anno) Anno, dp.id_piloto FROM ft_participacion parti
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            WHERE parti.puesto_final_carrera <> 1 AND (parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3) AND (anno_ref IS NULL OR dt.id_tiempo = id_evnt)
                GROUP BY id_piloto) pp ON pp.id_piloto = pilot.id_piloto
                ORDER BY  Anno;
    END;
$$;

--REPORTE 14
--EJ: SELECT * FROM reporte_pilotos_nunca_meta()
--DROP FUNCTION reporte_pilotos_nunca_meta();
CREATE OR REPLACE FUNCTION reporte_pilotos_nunca_meta(anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE (
        CantAbandonos BIGINT,
        Anno NUMERIC(4),
        NombrePiloto TEXT,
        Gentilicio VARCHAR(60),
        ImgBanderaPiloto TEXT,
        ImgPiloto TEXT
        ) LANGUAGE plpgsql AS $$

    BEGIN
        RETURN QUERY SELECT parti_a.CantAbandono VecesAbandono ,dt.Anno, pilot.nombre || ' ' || pilot.apellido NombrePiloto, pilot.gentilicio, pilot.img_bandera, pilot.img_piloto FROM dim_piloto pilot
            INNER JOIN ft_participacion ON pilot.id_piloto = ft_participacion.id_dim_piloto
            INNER JOIN dim_tiempo dt on ft_participacion.id_dim_tiempo = dt.id_tiempo
            INNER JOIN (SELECT count(*) CantAbandono, pilot.id_piloto FROM dim_piloto pilot INNER JOIN ft_participacion fp on pilot.id_piloto = fp.id_dim_piloto WHERE (fp.estado = 'a') GROUP BY pilot.id_piloto) parti_a ON parti_a.id_piloto = pilot.id_piloto
        ORDER BY  Anno;
    END;
$$;

--REPORTE 15
--VICTORIA POR MARCA
--True: marca auto
--False: marca neumatico
--SELECT * FROM reporte_victoria_por_marca(FALSE);
CREATE OR REPLACE FUNCTION reporte_victoria_por_marca(marca_auto BOOLEAN DEFAULT TRUE)
    RETURNS TABLE (
        CantidadVictoria BIGINT,
        Fabricante VARCHAR(30)
    ) LANGUAGE plpgsql AS $$
BEGIN
    IF marca_auto IS TRUE THEN
        --Marca de auto
        RETURN QUERY SELECT COUNT(*) CantVic, dv.fabricante_auto fabAuto FROM ft_participacion parti
            INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
        WHERE parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3
        GROUP BY fabAuto
        ORDER BY CantVic DESC;
    ELSE
        --Marca de neumatico
          RETURN QUERY SELECT COUNT(*) CantVic, dv.fabricante_neumatico fabNeu FROM ft_participacion parti
                INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
            WHERE parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3
            GROUP BY fabNeu
            ORDER BY CantVic DESC;
        end if;
END;
$$;


--REPORTE 16
--MUJERE PILOTO

--LOGROS DE PILOTO
--SELECT * FROM reporte_mujeres_pilotos();
DROP FUNCTION  reporte_mujeres_pilotos(anno_ref SMALLINT);
CREATE OR REPLACE FUNCTION reporte_mujeres_pilotos(anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE(
        AnnoPrimeraParticipacion NUMERIC(4),
        CantParticipaciones BIGINT,
        CantPrimerLugar BIGINT,
        CantPodium BIGINT,
        NombrePiloto TEXT,
        FechaNacimiento DATE,
        FechaFallecimiento DATE,
        Edad  DOUBLE PRECISION,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT
                 ) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT DISTINCT --Año de primera participacion
               (SELECT MIN(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto =  pilot.id_piloto) AnnoPrimeraParticipacion,
               --Numero total de participaciones
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto) CantParticipaciones,
                --Veces en el 1er puesto
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND parti.puesto_final_carrera = 1) CantPrimerLugar,
               --Veces en el podium (1,2 y3er lugar)
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND( parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3)) CantPodium,
                --Datos
                p.nombre || ' ' || p.apellido NombrePiloto, p.fec_nacimiento, p.fec_fallecimiento,  EXTRACT(YEAR FROM age(p.fec_nacimiento)), p.img_piloto, p.gentilicio, p.img_bandera BanderaPiloto
        FROM ft_participacion parti
            INNER JOIN dim_piloto p on parti.id_dim_piloto = p.id_piloto and p.genero = 'femenino'
        WHERE (anno_ref IS NULL OR parti.id_dim_tiempo = id_evnt );
    END;
$$;

-- DATOS PARTICIPACIONES
--SELECT * FROM reporte_datos_participacion_mujeres()
CREATE OR REPLACE FUNCTION reporte_datos_participacion_mujeres(anno_ref SMALLINT DEFAULT NULL)
    RETURNS TABLE (
        FechaPartipacion numeric(4),
         NroEquipo NUMERIC(3),
         VehCategoria CHAR(7),
         NombreEquipo VARCHAR(35),
        PaisEquipo VARCHAR(56),
        imgBanderaPais TEXT,
        ImgVehiculo TEXT,
        NombreVehiculo VARCHAR(30),
        NombrePiloto TEXT,
        ImgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT) LANGUAGE plpgsql AS $$
    DECLARE
        id_evnt SMALLINT;
    BEGIN
        IF anno_ref IS NOT NULL THEN
            id_evnt := obt_evento_id(anno_ref);
        END IF;

        RETURN QUERY SELECT dt.anno, parti.nro_equipo, dv.categoria, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, de.img_bandera ImgBanderaPais, dv.img_vehiculo, dv.modelo ModeloVeh, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.img_piloto, dp.gentilicio, dp.img_bandera ImgBanderaPiloto FROM ft_participacion parti
            INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
            INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
            INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
            INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        WHERE (de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo) IN
              (SELECT de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo FROM ft_participacion parti
                INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
                INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
                INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
                INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto AND dp.genero = 'femenino')
        AND (anno_ref IS NULL OR parti.id_dim_tiempo = id_evnt );
    END;
$$;
