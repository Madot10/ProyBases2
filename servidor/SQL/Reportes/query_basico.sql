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

--(carrera)  (ant_resumen.estadistica).puesto puesto_ant,
-- AUN LE FALTA
SELECT  sucesos.hora, (resumen_datos.estadistica).puesto, car.puesto_final final_act, ant_car.puesto_final final_ant, resumen_datos.nro_vueltas,e.nombre AS NombreTeam, pilot.identificacion, country.gentilicio, parti.nro_equipo, ps.nombre AS TeamPais, v.modelo, v.modelo_motor, v.categoria
FROM participaciones AS parti
    INNER JOIN carreras car ON parti.nro_equipo = car.parti_nro_equipo and parti.id_vehiculo = car.id_parti_vehiculo and parti.id_equipo = car.id_parti_equipo and parti.id_evento = car.id_parti_evento and parti.id_event_pista = car.id_parti_evento_pista
    INNER JOIN resumen_datos ON car.id_carrera = resumen_datos.id_carrera and car.parti_nro_equipo = resumen_datos.car_nro_equipo and car.id_parti_vehiculo = resumen_datos.id_car_vehiculo and car.id_parti_equipo = resumen_datos.id_car_equipo and car.id_parti_evento = resumen_datos.id_car_evento and car.id_parti_evento_pista = resumen_datos.id_car_pista
    --diferencia con anterior
    INNER JOIN carreras ant_car ON  ant_car.id_parti_evento = parti.id_evento  and  ant_car.id_parti_evento_pista = parti.id_event_pista and car.puesto_final = (ant_car.puesto_final - 1) and ant_car.id_carrera <> car.id_carrera
    --INNER JOIN resumen_datos ant_resumen ON  ant_car.id_carrera = ant_resumen.id_carrera and ant_car.parti_nro_equipo = ant_resumen.car_nro_equipo and ant_car.id_parti_vehiculo = ant_resumen.id_car_vehiculo and ant_car.id_parti_equipo = ant_resumen.id_car_equipo and ant_car.id_parti_evento = ant_resumen.id_car_evento and ant_car.id_parti_evento_pista = ant_resumen.id_car_pista
    --
    INNER JOIN sucesos ON resumen_datos.id_suceso = sucesos.id_suceso and resumen_datos.id_suceso_evento = sucesos.id_evento and resumen_datos.id_suceso_pista = sucesos.id_event_pista
    INNER JOIN vehiculos v ON parti.id_vehiculo = v.id_vehiculo
    INNER JOIN equipos e ON parti.id_equipo = e.id_equipo
    INNER JOIN plantillas p on parti.nro_equipo = p.parti_nro_equipo and parti.id_vehiculo = p.id_parti_vehiculo and parti.id_equipo = p.id_parti_equipo and parti.id_evento = p.id_parti_evento and parti.id_event_pista = p.id_parti_evento_pista
    INNER JOIN pilotos pilot on p.id_piloto = pilot.id_piloto
    INNER JOIN paises ps ON e.id_pais = ps.id_pais
    INNER JOIN paises country ON country.id_pais = pilot.id_pais
WHERE parti.id_evento = 1 AND sucesos.hora = 24;