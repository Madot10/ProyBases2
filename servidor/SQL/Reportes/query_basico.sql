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

