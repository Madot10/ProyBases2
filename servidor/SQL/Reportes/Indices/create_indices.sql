--Indice #1 Reporte #16 - Pilotos mujeres 
--Probado Para la BD grupo 7
--EJ: SELECT * FROM persona WHERE femenino is true; 
--Solo para pruebas
CREATE INDEX index_pilotos_mujeres ON persona (femenino) WHERE femenino is TRUE;

--Progbado para la BD le vams 
--EJ: SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';
--Para observar su uso EXPLAIN SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';

CREATE INDEX index_pilotos_mujeres ON pilotos (identificacion) WHERE (pilotos.identificacion).genero = 'f';

/*EXPLAIN SELECT DISTINCT pilot.id_piloto, EXTRACT(YEAR FROM(SELECT MIN(e.fecha) FROM participaciones p  INNER JOIN plantillas p2 on p.nro_equipo = p2.parti_nro_equipo and p.id_vehiculo = p2.id_parti_vehiculo and p.id_equipo = p2.id_parti_equipo and p.id_evento = p2.id_parti_evento and p.id_event_pista = p2.id_parti_evento_pista INNER JOIN pilotos p3 on p2.id_piloto = p3.id_piloto INNER JOIN eventos e on p.id_evento = e.id_evento and p.id_event_pista = e.id_pista WHERE  p2.id_piloto = pilot.id_piloto)) AnnoPrimeraParticipacion,
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
WHERE (pilot.identificacion).genero = 'f';*/


--Indice  Reporte #5 - Logros por Piloto
--Probado para la BD le vams
--EJ: EXPLAIN SELECT identificacion FROM pilotos WHERE (pilotos.identificacion).primer_nombre = 'Frank';

--CREATE INDEX index_logro_piloto ON pilotos (identificacion) WHERE (pilotos.identificacion).primer_nombre = 'Frank';

--Indice  Reporte #15 - Victorias por Marca
--Probado para la BD le vams
--EJ: explain select * from CARRERAS where puesto_final > 1 or puesto_final <= 3;

CREATE INDEX index_vict_marca ON carreras (puesto_final) WHERE puesto_final > 1 or puesto_final <= 3;




