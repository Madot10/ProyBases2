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
