-- REPORTE 1
-- Ranking por año
-- P. ENTRADA: Año y Categoría del auto
-- ORDENAR:  Tipo de evento (Ensayo o Carrera)
-- SALIDA (comun):   Equipo (Nombre, Número, Nacionalidad), Pilotos (Nombre, Nacionalidad, Foto), Vehículo (Nombre, Motor, Categoría, Foto)
-- salida (ensayo): Puesto, Tiempo, Velocidad media (Km/h)
-- salida (carrera) Puesto, Número de vueltas, Distancia en Km, Velocidad media (Km/h), Tiempo en la mejor vuelta, Diferencia con el puesto anterior

--(comun)DATOS de equipo y vehiculo
SELECT e.nombre, parti.nro_equipo, p.gentilicio, v.modelo, v.modelo_motor, v.categoria FROM participaciones AS parti
    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
    INNER JOIN paises p ON e.id_pais = p.id_pais
WHERE parti.id_evento = 1;

--(comun)DATOS piloto
SELECT parti.nro_equipo ,(pilot.identificacion).primer_nombre || ' ' || (pilot.identificacion).primer_apellido AS nombre, ps.gentilicio FROM participaciones AS parti
    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
    INNER JOIN paises ps on pilot.id_pais = ps.id_pais
WHERE parti.id_evento = 1;

--(comun)Intento de unir (datos triplicados*3)
SELECT e.nombre AS NombreTeam, pilot.identificacion, country.gentilicio, parti.nro_equipo, ps.nombre AS TeamPais, v.modelo, v.modelo_motor, v.categoria FROM participaciones AS parti
    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
    INNER JOIN paises ps ON e.id_pais = ps.id_pais
    INNER JOIN paises country ON country.id_pais = pilot.id_pais
WHERE parti.id_evento = 1;

--(ensayo)
SELECT eny.estadistica AS estadistica_ensayo  ,e.nombre AS NombreTeam, pilot.identificacion, country.gentilicio, parti.nro_equipo, ps.nombre AS TeamPais, v.modelo, v.modelo_motor, v.categoria FROM participaciones AS parti
    INNER JOIN ensayos eny ON parti.nro_equipo = eny.parti_nro_equipo and parti.id_vehiculo = eny.id_parti_vehiculo and parti.id_equipo = eny.id_parti_equipo and parti.id_evento = eny.id_parti_evento and parti.id_event_pista = eny.id_parti_evento_pista
    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
    INNER JOIN paises ps ON e.id_pais = ps.id_pais
    INNER JOIN paises country ON country.id_pais = pilot.id_pais
WHERE parti.id_evento = 1 ORDER BY (eny.estadistica).puesto;

--(carrera) 
-- En caso de diferencia 0, se coloca 1 vueltas
SELECT  sucesos.hora, (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) AS dif, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END dif_vueltas,car.puesto_final final_act, ant_car.puesto_final final_ant, resumen_datos.nro_vueltas,e.nombre AS NombreTeam, pilot.identificacion, country.gentilicio, parti.nro_equipo, ps.nombre AS TeamPais, v.modelo, v.modelo_motor, v.categoria
FROM participaciones AS parti
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
    INNER JOIN paises ps ON e.id_pais = ps.id_pais
    INNER JOIN paises country ON country.id_pais = pilot.id_pais
WHERE parti.id_evento = 2 AND sucesos.hora = 24 AND car.puesto_final <> 0 ORDER BY car.puesto_final;

-- REPORTE 1
-- FALTA foto piloto, bandera pais, vehiculo
SELECT e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, p_pilot.gentilicio, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
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
WHERE parti.id_evento = 2 AND sucesos.hora = 24 AND car.puesto_final <> 0;
-- ORDER BY (eny.estadistica).puesto
-- ORDER BY car.puesto_final;


--REPORTE 2
-- Raking hora por hora
-- Entrada: Año, Hora y Categoría del auto
-- Salida: equipo, pilotos, vehiculos, nro de vuelta, distancia km, vel media, dif

-- Falta foto: piloto, vehiculo
SELECT sucesos.hora Hora,e.nombre NombreEquipo, parti.nro_equipo NroEquipo, p_eq.nombre PaisEquipo, (pilot.identificacion).primer_nombre || ' ' || (pilot.identificacion).primer_apellido AS NombrePiloto, p_pilot.gentilicio, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
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
WHERE parti.id_evento = 1 ORDER BY sucesos.hora

--Reporte 3
-- Ganadores de las 24 horas de Le Mans:
-- (Entrada): Año y categoria
-- Si no se especifica el año, se muestran los ganadores de acuerdo a su década
-- SALIDA (comun):   Equipo (Nombre, Número, Nacionalidad), Pilotos (Nombre, Nacionalidad, Foto), Vehículo (Nombre, Motor, Categoría, Foto)
-- salida (ensayo): Puesto, Tiempo, Velocidad media (Km/h)
-- salida (carrera) Puesto, Número de vueltas, Distancia en Km, Velocidad media (Km/h), Tiempo en la mejor vuelta, Diferencia con el puesto anterior

--Obteniendo las posiciones mas altas por categ
SELECT v.categoria, MIN(c.puesto_final) FROM participaciones parti
    INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
    INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
    INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
WHERE c.puesto_final <> 0
    GROUP BY v.categoria;

-- Falta foto: piloto, vehiculo
SELECT e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, p_pilot.gentilicio, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
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
WHERE  sucesos.hora = 24 AND car.puesto_final <> 0 AND
      (v.categoria, car.puesto_final) IN
      (SELECT v.categoria, MIN(c.puesto_final) FROM participaciones parti
        INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
        INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
        INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
       WHERE c.puesto_final <> 0
        GROUP BY v.categoria);


--OBTENER CLIMA
--DROP FUNCTION obtener_metereologia_evento (anno_event SMALLINT);
--Ej: SELECT * FROM obtener_metereologia_evento(2020::smallint)
CREATE OR REPLACE FUNCTION obtener_metereologia_evento (anno_event SMALLINT)
    RETURNS TABLE (
        clima CHAR(2),
        hora NUMERIC(2)
                  ) LANGUAGE plpgsql AS $$
    DECLARE
    BEGIN
        RETURN QUERY SELECT (s.metereologia).clima, s.hora FROM sucesos s WHERE s.id_evento = obt_evento_id(anno_event) ORDER BY s.hora;
    END;
$$;


--REPORTE 4 POR NUM DE EQUIPO
--DADO UN ANNO
SELECT ev.fecha FechaEvento, e.nombre NombreEquipo, p.parti_nro_equipo NroEquipo, p_eq.nombre PaisEquipo, p_eq.img_bandera,  ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera, v.modelo NombreVehiculo, (v.modelo_motor).modelo ModeloMotor, (v.modelo_motor).cc, (v.modelo_motor).cilindros, v.categoria, v.img_vehiculo, (eny.estadistica).puesto PuestoEnsayo, (eny.estadistica).tiempo_mejor_vuelta MejorVueltaEnsayo, (eny.estadistica).velocidad_media VelMediaEnsayo, (resumen_datos.estadistica).puesto PuestoCarrera, resumen_datos.nro_vueltas NroVueltasCarrera, (resumen_datos.nro_vueltas * pistas.total_km) DistRecorrida, (resumen_datos.estadistica).velocidad_media VelMediaCarrera, (resumen_datos.estadistica).tiempo_mejor_vuelta MejorVueltaCarrera, CASE WHEN (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas)=0 THEN 1 ELSE (resumen_datos.nro_vueltas  - ant_resumen.nro_vueltas) END DifVueltas
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
                WHERE ( 1 IS NULL OR parti.id_evento = 1)  AND sucesos.hora = 24 AND car.puesto_final <> 0 AND parti.nro_equipo = 1 ORDER BY car.puesto_final;

--REPORTE 5 

--Datos 1era participacion
SELECT MIN(e.fecha) FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto
    INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista
    WHERE  p2.id_piloto = 180;

--Numero de veces total de participaciones
SELECT COUNT(p.id_evento) FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto
    WHERE  p2.id_piloto = 1;

--3 primeros lugares de una cat en la decada
SELECT dt.fecha, dt.nro_equipo FROM
              (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti
                    INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                    INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                    INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
                WHERE c.puesto_final <> 0
                ORDER BY c.puesto_final, v.categoria) dt
    WHERE dt.r_num <= 3;

--Numero de veces en 1er lugar
SELECT count(c.puesto_final) FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto
    INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista
    INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista
WHERE  p2.id_piloto = 1 AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM
                  (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti
                        INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                        INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                        INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                        INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
                    WHERE c.puesto_final <> 0
                    ORDER BY c.puesto_final, v.categoria) dt
        WHERE dt.r_num <= 1);

--Numero de veces en el podium(1,2 y3er lugar)
SELECT count(c.puesto_final) FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto
    INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista
    INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista
WHERE  p2.id_piloto = 1 AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM
                  (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti
                        INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                        INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                        INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                        INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
                    WHERE c.puesto_final <> 0
                    ORDER BY c.puesto_final, v.categoria) dt
        WHERE dt.r_num <= 3)


--REPORTE 5
--5.1 -DATOS PILOTO
SELECT EXTRACT(YEAR FROM(SELECT MIN(e.fecha) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto)) AnnoPrimeraParticipacion,
     --Cant participaciones
    (SELECT COUNT(p.id_evento) FROM participaciones p INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto WHERE  p2.id_piloto = pilot.id_piloto) CantParticipaciones,
    --Cant de veces en 1er lugar
    (SELECT COUNT(c.puesto_final) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti INNER JOIN equipos on parti.id_equipo = equipos.id_equipo INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo  INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista  WHERE c.puesto_final <> 0 ORDER BY c.puesto_final, v.categoria) dt WHERE dt.r_num <= 1)) CantPrimerLugar,
    --Cant de veces en el podium
    (SELECT COUNT(c.puesto_final) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto AND (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti INNER JOIN equipos on parti.id_equipo = equipos.id_equipo INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo  INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista  WHERE c.puesto_final <> 0 ORDER BY c.puesto_final, v.categoria) dt WHERE dt.r_num <= 3)) CantPodium,
    --Datos del piloto
    ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.fec_nacimiento FechaNacimiento, pilot.fec_fallecimiento FechaFallecimiento, extract(YEAR FROM age(pilot.fec_nacimiento)) Edad ,pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera
       FROM participaciones AS parti
        INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
        INNER JOIN equipos eq ON parti.id_equipo = eq.id_equipo
        INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
        INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais
    WHERE pilot.id_piloto = 1

--DETALLES DE PARTICIPACION
--Parti donde ha estado un piloto dado
SELECT parti.nro_equipo, parti.id_vehiculo, parti.id_equipo, parti.id_evento, parti.id_event_pista FROM participaciones parti
    INNER JOIN plantillas p2 on parti.nro_equipo = p2.parti_nro_equipo and parti.id_vehiculo = p2.id_parti_vehiculo and parti.id_equipo = p2.id_parti_equipo and parti.id_evento = p2.id_parti_evento and parti.id_event_pista = p2.id_parti_evento_pista
    WHERE  p2.id_piloto = 1;

--5.2 - Datos participaciones dado un piloto
SELECT  evt.fecha FechaPartipacion, parti.nro_equipo NroEquipo, veh.categoria VehCategoria, eq.nombre EquipoNombre, p_equipo.nombre PaisEquipo, veh.img_vehiculo ImgVehiculo, Veh.modelo VehModelo, ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombreOtroPiloto, pilot.img_piloto ImgOtroPiloto, p_pilot.gentilicio GentilicioOtro, p_pilot.img_bandera ImgBanderaOtro,
    ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.fec_nacimiento FechaNacimiento, pilot.fec_fallecimiento FechaFallecimiento, extract(YEAR FROM age(pilot.fec_nacimiento)) Edad ,pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera
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
                    WHERE  p2.id_piloto = 1);



--REPORTE 6
--Participacion segun marca(fabricante_auto) y modelo de Veh
SELECT EXTRACT(YEAR FROM ev.fecha), veh.modelo Modelo, veh.fabricante_auto Fabricante, veh.tipo TipoVeh, img_vehiculo ImgVehiculo, (veh.modelo_motor).modelo ModeloMotor, (veh.modelo_motor).cc, (veh.modelo_motor).cilindros, veh.fabricante_neumatico FabNeumatico, e.nombre NombreEquipo, p.nro_equipo NroEquipo, ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto, p_pilot.gentilicio, p_pilot.img_bandera
FROM vehiculos veh
    INNER JOIN participaciones p on veh.id_vehiculo = p.id_vehiculo
    INNER JOIN eventos ev on p.id_evento = ev.id_evento and p.id_event_pista = ev.id_pista
    INNER JOIN equipos e on p.id_equipo = e.id_equipo
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
    INNER JOIN paises p_pilot on pilot.id_pais = p_pilot.id_pais


--Edad al momento del evento
SELECT age(e.fecha, pilotos.fec_nacimiento) FROM pilotos
    INNER JOIN plantillas p on pilotos.id_piloto = p.id_piloto
    INNER JOIN participaciones parti on p.parti_nro_equipo = parti.nro_equipo and p.id_parti_vehiculo = parti.id_vehiculo and p.id_parti_equipo = parti.id_equipo and p.id_parti_evento = parti.id_evento and p.id_parti_evento_pista = parti.id_event_pista
    INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista


--REPORTE 7/8
SELECT EXTRACT(YEAR FROM MIN(age(e.fecha, pil.fec_nacimiento))) edad, EXTRACT(YEAR FROM e.fecha) AnnoParticipacion, ((pil.identificacion).primer_nombre || ' ' ||  (pil.identificacion).primer_apellido) NombrePiloto, p_piloto.gentilicio Gentilicio, pil.img_piloto ImgPiloto, p_piloto.img_bandera ImgBanderaPiloto FROM pilotos pil
    INNER JOIN plantillas p on pil.id_piloto = p.id_piloto
    INNER JOIN participaciones parti on p.parti_nro_equipo = parti.nro_equipo and p.id_parti_vehiculo = parti.id_vehiculo and p.id_parti_equipo = parti.id_equipo and p.id_parti_evento = parti.id_evento and p.id_parti_evento_pista = parti.id_event_pista
    INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
    INNER JOIN paises p_piloto on pil.id_pais = p_piloto.id_pais
GROUP BY NombrePiloto,AnnoParticipacion,Gentilicio, ImgPiloto, ImgBanderaPiloto ORDER BY edad LIMIT 1

--Pilotos con mayor num de participaciones
SELECT pilot.id_piloto Id FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
GROUP BY Id HAVING COUNT(p.id_evento) > ((SELECT COUNT(*) FROM eventos) - 1);

--REPORTE 9
--DATOS PILOTOS CON MAYOR NUMERO DE PARTICIPACIONES
SELECT ((pilot.identificacion).primer_nombre || ' ' ||  (pilot.identificacion).primer_apellido) NombrePiloto, pilot.img_piloto ImgPiloto, p.gentilicio, p.img_bandera ImgBanderaPiloto
FROM pilotos pilot
    INNER JOIN paises p on pilot.id_pais = p.id_pais
WHERE pilot.id_piloto IN (SELECT pilot.id_piloto Id FROM participaciones p
        INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
        INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
    GROUP BY Id HAVING COUNT(p.id_evento) > ((SELECT COUNT(*) FROM eventos) - 1))

--REPORTE 10
--Primera participacion de pilotos
SELECT MIN(evt.fecha) Fecha, pilot.id_piloto PilotoID FROM eventos evt
    INNER JOIN participaciones p on evt.id_evento = p.id_evento and evt.id_pista = p.id_event_pista
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
GROUP BY PilotoID

--GANADOR EN SU PRIMERA PARTICIPACION
SELECT EXTRACT(YEAR FROM e.fecha), ((pil.identificacion).primer_nombre || ' ' ||  (pil.identificacion).primer_apellido) NombrePiloto, p_piloto.gentilicio Gentilicio, pil.img_piloto ImgPiloto, p_piloto.img_bandera ImgBanderaPiloto FROM pilotos pil
    --Primera participacion
    INNER JOIN (SELECT MIN(evt.fecha) Fecha, pilot.id_piloto PilotoID FROM eventos evt
                    INNER JOIN participaciones p on evt.id_evento = p.id_evento and evt.id_pista = p.id_event_pista
                    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
                    INNER JOIN pilotos pilot on p2.id_piloto = pilot.id_piloto
                GROUP BY PilotoID) pr_parti ON pr_parti.PilotoID = pil.id_piloto
    INNER JOIN plantillas p3 on pil.id_piloto = p3.id_piloto
    INNER JOIN participaciones parti on p3.parti_nro_equipo = parti.nro_equipo and p3.id_parti_vehiculo = parti.id_vehiculo and p3.id_parti_equipo = parti.id_equipo and p3.id_parti_evento = parti.id_evento and p3.id_parti_evento_pista = parti.id_event_pista
    INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista AND e.fecha = pr_parti.Fecha
    --Primer lugar de una cat
    INNER JOIN (SELECT dt.fecha, dt.nro_equipo FROM
              (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti
                    INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                    INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                    INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                    INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
                WHERE c.puesto_final <> 0
                ORDER BY c.puesto_final, v.categoria) dt
                 WHERE dt.r_num <= 1) cat_win ON cat_win.nro_equipo = parti.nro_equipo AND cat_win.fecha = e.fecha
    INNER JOIN paises p_piloto on pil.id_pais = p_piloto.id_pais;


--REPORTE 13
-- EN el podium pero no en el 1er lugar
SELECT p2.id_piloto FROM participaciones p
    INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista
    INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto
    INNER JOIN carreras c on p.nro_equipo = c.parti_nro_equipo and p.id_vehiculo = c.id_parti_vehiculo and p.id_equipo = c.id_parti_equipo and p.id_evento = c.id_parti_evento and p.id_event_pista = c.id_parti_evento_pista
    INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista
WHERE  (e.fecha, p.nro_equipo) IN (SELECT dt.fecha, dt.nro_equipo FROM
                  (SELECT e.fecha, parti.nro_equipo, row_number() over (PARTITION By e.fecha, v.categoria ORDER BY c.puesto_final) r_num FROM participaciones parti
                        INNER JOIN equipos on parti.id_equipo = equipos.id_equipo
                        INNER JOIN carreras c on parti.nro_equipo = c.parti_nro_equipo and parti.id_vehiculo = c.id_parti_vehiculo and parti.id_equipo = c.id_parti_equipo and parti.id_evento = c.id_parti_evento and parti.id_event_pista = c.id_parti_evento_pista
                        INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
                        INNER JOIN eventos e on parti.id_evento = e.id_evento and parti.id_event_pista = e.id_pista
                    WHERE c.puesto_final <> 0
                    ORDER BY c.puesto_final, v.categoria) dt
        WHERE dt.r_num <= 3 AND dt.r_num <> 1)

