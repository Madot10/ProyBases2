-- REPORTE 1 - Ranking por año
-- order_by: eny o car
-- EJ: SELECT * FROM reporte_rank_anno(2000::smallint, 'LMP 900', 'eny');
--DROP FUNCTION reporte_rank_anno(anno_ref SMALLINT, cat_v CHAR, order_by CHAR);


CREATE OR REPLACE FUNCTION reporte_rank_anno(anno_ref SMALLINT, cat_v CHAR(7) DEFAULT NULL, order_by CHAR(3) DEFAULT 'car')
    RETURNS TABLE (
        NombreEquipo VARCHAR(35),
        NroEquipo NUMERIC(3),
        PaisEquipo VARCHAR(56),
        imgBanderaEquipo TEXT,
        NombrePiloto TEXT,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT,
        NombreVehiculo VARCHAR(30),
        ModeloMotor VARCHAR(30),
        cc NUMERIC(4),
        cilindros VARCHAR(3),
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
    declare
        id_evnt SMALLINT;
    begin
        id_evnt := obt_evento_id(anno_ref);
        IF cat_v is not NULL then
            IF order_by = 'eny' THEN
               --Ordenamiento por ensayo
                RETURN QUERY SELECT e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
                FROM participaciones AS parti
                    INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                    INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                    INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                    INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                    --diferencia con anterior
                    INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                    INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
                    --
                    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                    INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                    INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                    INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
                WHERE parti.id_evento = id_evnt AND sucesos.hora = 24 AND v.categoria = cat_v AND car.puesto_final <> 0 ORDER BY (eny.estadistica).puesto;
            ELSE
                --Ordenamiento por Carrera
                RETURN QUERY SELECT e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
                FROM participaciones AS parti
                    INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                    INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                    INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                    INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                    --diferencia con anterior
                    INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                    INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
                    --
                    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                    INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                    INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                    INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
                WHERE parti.id_evento = id_evnt AND sucesos.hora = 24 AND v.categoria = cat_v AND car.puesto_final <> 0 ORDER BY car.puesto_final;
           END IF;
        ELSE
            --Ordenamiento por Carrera sin tomar en cuenta la categoría
            RETURN QUERY SELECT e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, nrovueltas.suma  NroVueltasCarrera, (nrovueltas.suma * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (nrovueltas.suma  - ant_nrovueltas.suma)=0 THEN 1 ELSE (nrovueltas.suma  - ant_nrovueltas.suma) END DifVueltas
                FROM participaciones AS parti
                    INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                    INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                    INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                    INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                    --diferencia con anterior
                    INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                    INNER JOIN (SELECT parti.nro_equipo nroteam, (SELECT SUM(rd.nro_vueltas)  FROM resumen_datos rd WHERE  rd.id_suceso_evento = id_evnt AND rd.car_nro_equipo = parti.nro_equipo GROUP BY rd.car_nro_equipo) suma FROM participaciones parti  WHERE parti.id_evento = id_evnt) ant_nrovueltas ON ant_nrovueltas.nroteam = ant_car.parti_nro_equipo
                    -- vueltas totales
                    INNER JOIN (SELECT parti.nro_equipo nroteam, (SELECT SUM(rd.nro_vueltas)  FROM resumen_datos rd WHERE  rd.id_suceso_evento = id_evnt AND rd.car_nro_equipo = parti.nro_equipo GROUP BY rd.car_nro_equipo) suma FROM participaciones parti  WHERE parti.id_evento = id_evnt) nrovueltas ON nrovueltas.nroteam = car.parti_nro_equipo
                    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                    INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                    INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                    INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
                WHERE parti.id_evento = id_evnt AND sucesos.hora = 24 AND car.puesto_final <> 0 ORDER BY car.puesto_final;
        END IF;
    end;
$$;



-- REPORTE 2
-- Raking hora por hora
-- Entrada: Año, Hora y Categoría del auto
-- Salida: equipo, pilotos, vehiculos, nro de vuelta, distancia km, vel media, dif
-- DROP FUNCTION  reporte_ranking_hora(anno_ref SMALLINT, hora_ref SMALLINT, cat_v CHAR);
-- EJ: SELECT * FROM reporte_ranking_hora(2000::smallint, 2::smallint, 'LMP 900');


CREATE OR REPLACE FUNCTION reporte_ranking_hora(anno_ref SMALLINT, hora_ref SMALLINT, cat_v CHAR(7))
    RETURNS TABLE(
        Hora NUMERIC(2),
        NombreEquipo VARCHAR(35),
        NroEquipo NUMERIC(3),
        PaisEquipo VARCHAR(56),
        imgBanderaEquipo TEXT,
        NombrePiloto TEXT,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT,
        NombreVehiculo VARCHAR(30),
        ModeloMotor VARCHAR(30),
        cc NUMERIC(4),
        cilindros VARCHAR(3),
        categoria CHAR(7),
        imgVehiculo TEXT,
        PuestoCarrera NUMERIC(3),
        NroVueltasCarrera NUMERIC(3),
        DistRecorrida NUMERIC(8),
        VelMediaCarrera NUMERIC(5,2),
        MejorVueltaCarrera TIME,
        DifVueltas NUMERIC(3)
                 ) LANGUAGE  plpgsql AS $$
    declare
        id_evnt SMALLINT;
    begin
       id_evnt := obt_evento_id(anno_ref);
        RETURN QUERY SELECT sucesos.hora Hora,e.nombre NombreEquipo, parti.nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera, (pilot.identificacion).primer_nombre || ' ' || (pilot.identificacion).primer_apellido AS NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
        FROM participaciones AS parti
            --EQUIPO
            INNER JOIN equipos e on parti.id_equipo = e.id_equipo
            INNER JOIN paises p_eq on e.id_pais = p_eq.id_pais
            --PILOTOS
            INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
            INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
            INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais
            --VEHICULO
            INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
            --Carrera
            INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
            INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
            INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
            --diferencia con anterior
            INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
            INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
            --
            INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
        WHERE parti.id_evento = id_evnt AND sucesos.hora = hora_ref AND v.categoria = cat_v AND car.puesto_final <> 0 ORDER BY sucesos.hora;
    end;
$$;

-- REPORTE 3
-- Ganadores de las 24 horas de Le Mans:
-- (Entrada): Año y categoria
-- Si no se especifica el año, se muestran los ganadores de acuerdo a su década
-- SALIDA (comun):   Equipo (Nombre, Número, Nacionalidad), Pilotos (Nombre, Nacionalidad, Foto), Vehículo (Nombre, Motor, Categoría, Foto)
-- salida (ensayo): Puesto, Tiempo, Velocidad media (Km/h)
-- salida (carrera) Puesto, Número de vueltas, Distancia en Km, Velocidad media (Km/h), Tiempo en la mejor vuelta, Diferencia con el puesto anterior
-- EJ: SELECT * FROM reporte_ganadores_le_mans('LMP 900',2000::smallint)

CREATE OR REPLACE FUNCTION reporte_ganadores_le_mans( cat_ref CHAR(7), anno_ref SMALLINT DEFAULT 0)
    RETURNS TABLE (
        FechaEvento TIMESTAMP,
        NombreEquipo VARCHAR(35),
        NroEquipo NUMERIC(3),
        PaisEquipo VARCHAR(56),
        imgBanderaEquipo TEXT,
        NombrePiloto TEXT,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT,
        NombreVehiculo VARCHAR(30),
        ModeloMotor VARCHAR(30),
        cc NUMERIC(4),
        cilindros VARCHAR(3),
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
    declare
         id_evnt SMALLINT;
    begin
        if anno_ref <> 0 then
            --usar anno de referencia
             id_evnt := obt_evento_id(anno_ref);
             RETURN QUERY SELECT ev.fecha FechaEvento , e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera, (pilot.identificacion).primer_nombre || ' ' || (pilot.identificacion).primer_apellido AS NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
            FROM participaciones AS parti
                INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                INNER JOIN eventos AS ev ON parti.id_evento = ev .id_evento and parti.id_event_pista = ev .id_pista
                --diferencia con anterior
                INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
                --
                INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
            WHERE  sucesos.hora = 24 AND car.puesto_final <> 0 AND parti.id_evento = id_evnt AND
                  (v.categoria, car.puesto_final) IN
                  (SELECT v.categoria, MIN(c.puesto_final) FROM participaciones parti
                    INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                    INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                    INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                   WHERE c.puesto_final <> 0 AND parti.id_evento = id_evnt AND v.categoria = cat_ref
                    GROUP BY v.categoria);
        else
            --toda la decada
            RETURN QUERY SELECT ev.fecha FechaEvento ,e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio,  p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
            FROM participaciones AS parti
                INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                INNER JOIN eventos AS ev ON parti.id_evento = ev .id_evento and parti.id_event_pista = ev .id_pista
                    --diferencia con anterior
                INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
                --
                INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
            WHERE  sucesos.hora = 24 AND car.puesto_final <> 0 AND
                  (v.categoria, car.puesto_final) IN
                  (SELECT v.categoria, MIN(c.puesto_final) FROM participaciones parti
                    INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                    INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                    INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                   WHERE c.puesto_final <> 0 AND v.categoria = cat_ref
                    GROUP BY v.categoria);
        end if;
    end;
$$;

--REPORTE 4
-- RANKING POR NRO DE EQUIPO
-- EJ: SELECT * FROM reporte_rank_nro_equipo(1::SMALLINT)
--EJ: SELECT * FROM reporte_rank_nro_equipo(1::SMALLINT, 2020::SMALLINT)
--EJ: SELECT * FROM reporte_rank_nro_equipo(NULL, 2020::SMALLINT)
CREATE OR REPLACE  FUNCTION  reporte_rank_nro_equipo(n_equipo NUMERIC(3) DEFAULT NULL, anno_ref SMALLINT DEFAULT NULL)
RETURNS TABLE (
        FechaEvento TIMESTAMP,
        NombreEquipo VARCHAR(35),
        NroEquipo NUMERIC(3),
        PaisEquipo VARCHAR(56),
        imgBanderaEquipo TEXT,
        NombrePiloto TEXT,
        imgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT,
        NombreVehiculo VARCHAR(30),
        ModeloMotor VARCHAR(30),
        cc NUMERIC(4),
        cilindros VARCHAR(3),
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

         RETURN QUERY SELECT ev.fecha FechaEvento, e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
                FROM participaciones AS parti
                    INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
                    INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
                    INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
                    INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
                    INNER JOIN eventos AS ev ON parti.id_evento = ev .id_evento and parti.id_event_pista = ev .id_pista
                    --diferencia con anterior
                    INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
                    INNER JOIN resumen_datos ant_resumen ON ant_resumen.id_suceso = sucesos.id_suceso and ant_resumen.id_carrera = ant_car.id_carrera  and  ant_resumen.car_nro_equipo= ant_car.parti_nro_equipo and ant_resumen.id_car_vehiculo = ant_car.id_parti_vehiculo  and ant_resumen.id_car_equipo = ant_car.id_parti_equipo and ant_resumen.id_car_evento = ant_car.id_parti_evento  and ant_resumen.id_car_pista = ant_car.id_parti_evento_pista
                    --
                    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
                    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                    INNER JOIN pistas ON pistas.id_pista = parti.id_event_pista
                    INNER JOIN paises p_eq ON e.id_pais = p_eq.id_pais
                    INNER JOIN paises p_pilot ON p_pilot.id_pais = pilot.id_pais
                WHERE ( anno_ref IS NULL OR parti.id_evento = id_evnt)  AND sucesos.hora = 24 AND car.puesto_final <> 0 AND ( n_equipo IS NULL OR parti.nro_equipo = n_equipo) ORDER BY car.puesto_final;
    END;
$$;

--REPORTE 5 (2 partes)
--LOGROS DE PILOTO
--EJ: SELECT * FROM reporte_logros_piloto(1::smallint)
--DROP FUNCTION  reporte_logros_piloto(id_pilot SMALLINT)
--5.1 DATOS PILOTO
CREATE OR REPLACE FUNCTION reporte_logros_piloto(id_pilot SMALLINT)
    RETURNS TABLE(
        AnnoPrimeraParticipacion DOUBLE PRECISION,
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
        RETURN QUERY SELECT EXTRACT(YEAR FROM(SELECT MIN(e.fecha) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto)) AnnoPrimeraParticipacion,
             --Cant participaciones
            (SELECT COUNT(p.id_evento) FROM participaciones p INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto WHERE  p2.id_piloto = pilot.id_piloto) CantParticipaciones,
            --Cant de veces en 1er lugar
            (SELECT COUNT(c.puesto_final) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti INNER JOIN equipos on parti.id_equipo = equipos.id_equipo INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo  INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista  WHERE c.puesto_final <> 0 ORDER BY c.puesto_final, v.categoria) dt WHERE dt.r_num <= 1)) CantPrimerLugar,
            --Cant de veces en el podium
            (SELECT COUNT(c.puesto_final) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti INNER JOIN equipos on parti.id_equipo = equipos.id_equipo INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo  INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista  WHERE c.puesto_final <> 0 ORDER BY c.puesto_final, v.categoria) dt WHERE dt.r_num <= 3)) CantPodium,
            --Datos del piloto
            ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.fec_nacimiento FechaNacimiento, pilot.fec_fallecimiento FechaFallecimiento, extract(YEAR FROM age(pilot.fec_nacimiento)) Edad ,pilot.img_piloto ImgPiloto, p_pilot.gentilicio Gentilicio, p_pilot.img_bandera ImgBanderaPiloto
               FROM participaciones AS parti
                INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
                INNER JOIN equipos eq ON parti.id_equipo = eq.id_equipo
                INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
                INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais
            WHERE pilot.id_piloto = id_pilot LIMIT 1;
    END;
$$;

--5.2 DATOS PARTICIPACIONES
--EJ: SELECT * FROM reporte_datos_participacion(1::smallint);
--Para ser llamado luego del anterior
CREATE OR REPLACE FUNCTION reporte_datos_participacion(id_pilot SMALLINT)
    RETURNS TABLE (
        FechaPartipacion timestamp,
         NroEquipo NUMERIC(3),
         VehCategoria CHAR(7),
         NombreEquipo VARCHAR(35),
        PaisEquipo VARCHAR(56),
        ImgVehiculo TEXT,
        NombreVehiculo VARCHAR(30),
        NombrePiloto TEXT,
        ImgPiloto TEXT,
        Gentilicio VARCHAR(60),
        imgBanderaPiloto TEXT) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT  evt.fecha FechaPartipacion, parti.nro_equipo NroEquipo, veh.categoria VehCategoria, eq.nombre NombreEquipo, p_equipo.nombre PaisEquipo, veh.img_vehiculo ImgVehiculo, Veh.modelo NombreVehiculo, ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto ImgPiloto, p_pilot.gentilicio Gentilicio, p_pilot.img_bandera imgBanderaPiloto
       FROM participaciones AS parti
        INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
        INNER JOIN eventos evt ON parti.id_evento = evt.id_evento and parti.id_event_pista = evt.id_pista
        INNER JOIN equipos eq ON parti.id_equipo = eq.id_equipo
        INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
        INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais
        INNER JOIN paises p_equipo on p_equipo.id_pais = eq.id_pais
        INNER JOIN vehiculos veh on parti.id_vehiculo = veh.id_vehiculo
    WHERE (parti.nro_equipo, parti.id_vehiculo, parti.id_equipo, parti.id_evento, parti.id_event_pista)
              IN (SELECT parti.nro_equipo, parti.id_vehiculo, parti.id_equipo, parti.id_evento, parti.id_event_pista FROM participaciones parti
                    INNER JOIN plantillas p2 on parti.nro_equipo = p2.parti_nro_equipo and parti.id_vehiculo = p2.id_parti_vehiculo and parti.id_equipo = p2.id_parti_equipo and parti.id_evento = p2.id_parti_evento and parti.id_event_pista = p2.id_parti_evento_pista
                    WHERE  p2.id_piloto = id_pilot);
    END;
$$;

--REPORTE 6
--Participacion segun marca(fabricante_auto) y modelo de Veh
--Ej: SELECT * FROM reporte_participaciones_marcas_modelos('Audi');
--Ej: SELECT * FROM reporte_participaciones_marcas_modelos();
CREATE OR REPLACE FUNCTION reporte_participaciones_marcas_modelos(marca VARCHAR(30) DEFAULT NULL, model VARCHAR(30) DEFAULT NULL)
RETURNS TABLE (
    AnnoParticipacion DOUBLE PRECISION,
    Modelo VARCHAR(30),
    Fabricante VARCHAR(30),
    TipoVeh CHAR(2),
    ImgVehiculo TEXT,
    ModeloMotor VARCHAR(30),
    cc NUMERIC(4),
    cilindros VARCHAR(3),
    FabNeumatico VARCHAR(30),
    NombreEquipo VARCHAR(35),
    NroEquipo NUMERIC(3),
    NombrePiloto TEXT,
    ImgPiloto TEXT,
    Gentilicio VARCHAR(30),
    ImgBanderaPiloto TEXT
              ) LANGUAGE plpgsql AS $$
    BEGIN
        RETURN QUERY SELECT EXTRACT(YEAR FROM ev.fecha) AnnoParticipacion, veh.modelo Modelo, veh.fabricante_auto Fabricante, veh.tipo TipoVeh, img_vehiculo ImgVehiculo, (veh.modelo_motor).modelo ModeloMotor, (veh.modelo_motor).cc, (veh.modelo_motor).cilindros, veh.fabricante_neumatico FabNeumatico, e.nombre NombreEquipo, p.nro_equipo NroEquipo, ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto ImgPiloto, p_pilot.gentilicio Gentilicio, p_pilot.img_bandera ImgBanderaPiloto
        FROM vehiculos veh
            INNER JOIN participaciones p on veh.id_vehiculo = p.id_vehiculo
            INNER JOIN eventos ev on p.id_evento = ev.id_evento and p.id_event_pista = ev.id_pista
            INNER JOIN equipos e on p.id_equipo = e.id_equipo
            INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
            INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
            INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais
        WHERE (marca IS NULL OR veh.fabricante_auto = marca) AND (model IS NULL OR veh.modelo = model);
    END;
$$;



