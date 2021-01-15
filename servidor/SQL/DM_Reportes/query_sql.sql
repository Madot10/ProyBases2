-- (BORRADOR) REPORTE 4
---( anno_ref IS NULL OR parti.id_evento = id_evnt)
SELECT t.anno, eq.nombre NombreEquipo, parti.nro_equipo, eq.nombre_pais PaisEquipo, eq.img_bandera BanderaEquipo,
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
WHERE (NULL IS NULL OR parti.id_dim_tiempo = 1) AND parti.nro_equipo = 1;


--REPORTE 5
--Año de primera participacion AnnoPrimeraParticipacion
SELECT MIN(t.anno) FROM ft_participacion parti
    INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto
    INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo
WHERE pilot.id_piloto = 500;

--Numero total de participaciones
SELECT COUNT(t.anno) FROM ft_participacion parti
    INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto
    INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo
WHERE pilot.id_piloto = 700;

--Veces en el 1er puesto
SELECT COUNT(t.anno) FROM ft_participacion parti
    INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto
    INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo
WHERE pilot.id_piloto = 700 AND parti.puesto_final_carrera = 1;

--Veces en el podium (1,2 y3er lugar)
SELECT COUNT(t.anno) FROM ft_participacion parti
    INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto
    INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo
WHERE pilot.id_piloto = 208 AND( parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3);

SELECT --Año de primera participacion
       (SELECT MIN(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto =  pilot.id_piloto) AnnoPrimeraParticipacion,
       --Numero total de participaciones
        (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto) CantParticipaciones,
        --Veces en el 1er puesto
        (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND parti.puesto_final_carrera = 1) CantPrimerLugar,
       --Veces en el podium (1,2 y3er lugar)
        (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND( parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3)) CantPodium,
        --Datos
        p.nombre || ' ' || p.apellido NombrePiloto, p.fec_nacimiento, p.fec_fallecimiento, p.gentilicio, EXTRACT(YEAR FROM age(p.fec_nacimiento)), p.img_bandera BanderaPiloto, p.img_piloto
FROM ft_participacion parti
    INNER JOIN dim_piloto p on parti.id_dim_piloto = p.id_piloto
WHERE p.id_piloto = 1

--Obtener ids donde ha participado
SELECT de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo FROM ft_participacion parti
    INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto AND dp.id_piloto = 1

--TABLA DETALLADA
SELECT dt.anno, parti.nro_equipo, dv.categoria, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, de.img_bandera ImgBanderaPais, dv.img_vehiculo, dv.modelo ModeloVeh, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.img_piloto, dp.gentilicio, dp.img_bandera ImgBanderaPiloto FROM ft_participacion parti
    INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
    INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
WHERE (de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo) IN
      (SELECT de.id_equipo, dt.id_tiempo, dv.id_vehiculo, parti.nro_equipo FROM ft_participacion parti
        INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
        INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
        INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
        INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto AND dp.id_piloto = 1)

--REPORTE 6
--Parti por marca y modelo de auto
SELECT dt.anno, dv.img_vehiculo, dv.fabricante_auto, dv.modelo, dv.tipo, dv.modelo_motor, dv.cilindros, dv.cc, dv.categoria, dv.fabricante_neumatico, de.nombre NombreEquipo, parti.nro_equipo, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.img_piloto, dp.gentilicio, dp.img_bandera imgBanderaPaisPiloto  FROM ft_participacion parti
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
    INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo

--REPORTE 7
--Piloto más joven

--Edad de mas jovenes por año
SELECT MIN(EXTRACT(YEAR FROM age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento))) Edad, dt.anno FROM ft_participacion parti
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
GROUP BY anno ORDER BY edad --LIMIT 1;

SELECT dt.anno, EXTRACT(YEAR FROM age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.gentilicio, dp.img_piloto FROM ft_participacion parti
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
WHERE (age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento), dt.anno) IN (SELECT MIN(age(to_date(dt.dia || '/' || dt.mes || '/'|| dt.anno,'DD/MM/YYYY'), dp.fec_nacimiento)) Edad, dt.anno FROM ft_participacion parti
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
GROUP BY anno ORDER BY edad )

--REPORTE 9
--Pilotos con + participaciones
SELECT COUNT(*) NroParti, dp.nombre || ' ' || dp.apellido NombrePiloto, dp.gentilicio, dp.img_piloto, dp.img_bandera FROM ft_participacion parti
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
GROUP BY  NombrePiloto, gentilicio, img_piloto, img_bandera ORDER BY NroParti DESC LIMIT 10;

--REPORTE 10
--GANADOR EN SU PRIMERA PARTICIPACION

-- Primera participacion y ganador
SELECT MIN(dt.anno), dp.id_piloto FROM ft_participacion parti
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
WHERE parti.puesto_final_carrera = 1
    GROUP BY id_piloto

SELECT pp.Anno, pilot.nombre || ' ' || pilot.apellido NombrePiloto, pilot.gentilicio, pilot.img_bandera, pilot.img_piloto FROM dim_piloto pilot
    INNER JOIN (SELECT MIN(dt.anno) Anno, dp.id_piloto FROM ft_participacion parti
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_piloto dp on parti.id_dim_piloto = dp.id_piloto
WHERE parti.puesto_final_carrera = 1
    GROUP BY id_piloto) pp ON pp.id_piloto = pilot.id_piloto
    ORDER BY  Anno

--REPORTE 11
--Ordenamiento carrera
SELECT DISTINCT dt.anno, dv.fabricante_auto, dv.modelo, dv.img_vehiculo, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, de.img_bandera, parti.velocidad_media_carrera FROM ft_participacion parti
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
    INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
ORDER BY parti.velocidad_media_carrera DESC LIMIT 15;

--Ordenamiento ensayo
SELECT DISTINCT dt.anno, dv.fabricante_auto, dv.modelo, dv.img_vehiculo, de.nombre NombreEquipo, de.nombre_pais PaisEquipo, de.img_bandera, parti.velocidad_media_ensayo FROM ft_participacion parti
    INNER JOIN dim_tiempo dt on parti.id_dim_tiempo = dt.id_tiempo
    INNER JOIN dim_vehiculo dv on parti.id_dim_vehiculo = dv.id_vehiculo
    INNER JOIN dim_equipo de on parti.id_dim_equipo = de.id_equipo
ORDER BY parti.velocidad_media_ensayo DESC LIMIT 15;