-- (SIM) Ciclo carrera
--Por cada hora de la carrera se ejecutarán acciones para todos los equipos participantes
--Falta probar
CREATE OR REPLACE FUNCTION simulacion_ciclo_carrera (id_event SMALLINT) AS $$
    DECLARE
    			cur_carrera CURSOR FOR SELECT * FROM carreras AS car WHERE car.id_parti_evento = id_event AND car.estado <> 'a' AND car.estado <> 'np' AND car.estado <> 'd';
    BEGIN
    		--24hrs
    		FOR hora IN 1..24 LOOP
        		--Loop de equipos: estado <> 'a', 'np' y 'd'
            FOR clasif_car IN cur_carrera LOOP
            	--(a) Generar velocidad media en la hora
            	call generar_veloc_media (id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
                --(b) Generar mejor tiempo  en la hora,
                call generar_mejor_tiempo_hora (id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
                --(c) Generar falla en un vehículo
                call generar_posible_falla (id_event, clasif_car.id_parti_evento_pista, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, clasif_car.id_parti_equipo, clasif_car.id_parti_vehiculo,  hora);
                
                ---(d) Verificar si hubo accidente colectivo en la hora
                call verificar_accidente_colectivo (id_event, hora, clasif_car.id_parti_equipo , clasif_car.parti_nro_equipo );
                
                --(f) Generar paradas en pits por motivo gasolina
                call  generar_paradas_gasolina(id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
                --(g) Generar paradas en pits por motivo neumático 
                call generar_paradas_neumatico(id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
                --(h) Generar paradas en pits por motivo de cambio de conductor (Cada 4horas)
                IF ((hora % 4) = 0) THEN
                	call generar_paradas_conductor (id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                END IF;
                
                --(i) Generar número de vueltas dadas en esa hora para el equipo
                call generar_nro_vueltas (id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
                --(j) Genera promedio temperatura del cockpit en esa hora
                call generar_temp_prom_cockpit (id_event, clasif_car.id_parti_equipo, clasif_car.parti_nro_equipo, hora);
                
            END LOOP;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;

--Generar clasificación de los participantes
--SELECT rd.car_nro_equipo, SUM(rd.nro_vueltas) total_vueltas FROM resumen_datos AS rd WHERE rd.id_suceso_evento = 11 GROUP BY rd.car_nro_equipo ORDER BY total_vueltas DESC;
CREATE OR REPLACE PROCEDURE clasificacion_final_car (id_event SMALLINT) AS $$
  DECLARE
  			cur_clasificacion CURSOR FOR SELECT rd.car_nro_equipo, SUM(rd.nro_vueltas) total_vueltas FROM resumen_datos AS rd WHERE rd.id_suceso_evento = id_event 
        																		GROUP BY rd.car_nro_equipo ORDER BY total_vueltas DESC;
  BEGIN
  		
  END;
$$ LANGUAGE plpgsql;










