--Procedimiento para borrar los datos de la simulación
-- FALTA COMPLETAR
CREATE OR REPLACE PROCEDURE borrar_simulacion(ano_evento SMALLINT)
    LANGUAGE plpgsql AS $$
    begin
        truncate table lotes_repuestos;
        delete from eventos AS e where e.id_evento = obt_evento_id(ano_evento);
    end;
$$;

--FUNCIONES AUXILIARES

--GENERADOR DE NUMEROS RANDOM EN UN RANGO
-- MIN y MAX parametros opcionales
-- Por defecto los genera entre 0 y 10
-- Ej: SELECT gen_random(10,20) => 13
CREATE OR REPLACE  FUNCTION gen_random(min INT DEFAULT 0, max INT DEFAULT 10)
    RETURNS INT LANGUAGE plpgsql AS $$
    BEGIN
        RETURN floor(min + (max - min) * RANDOM());
    END;
$$;

-- OBTENER EVENTO ID SEGUN FECHA
-- Ej: select obt_evento_id(2020); => 2
CREATE OR REPLACE FUNCTION obt_evento_id(fecha SMALLINT)
    RETURNS SMALLINT LANGUAGE plpgsql AS $$
    declare
        id_obt SMALLINT;
    begin
        SELECT e.id_evento INTO id_obt FROM eventos AS e WHERE EXTRACT(YEAR FROM e.fecha)::SMALLINT = obt_evento_id.fecha;
        RETURN id_obt;
    end;
$$;

-- OBTENER SUCESO EVENTO
--ENTRADA: Evento y hora
--SAlida: suceso id
--EJ: SELECT obtener_suceso_id(1::smallint, 1);
CREATE OR REPLACE FUNCTION obtener_suceso_id(id_event SMALLINT, hora NUMERIC(2)) RETURNS SMALLINT LANGUAGE plpgsql AS $$
	DECLARE
  	id_obtenido SMALLINT;
	BEGIN
  		SELECT s.id_suceso INTO id_obtenido FROM sucesos AS s WHERE s.id_evento = id_event AND s.hora = obtener_suceso_id.hora;
      RETURN id_obtenido;
  END;
$$;

-- PREDECIR CLIMA SEGUN CLIMA ANTERIOR
--EJ: SELECT gen_clima()
CREATE OR REPLACE FUNCTION predecir_clima(clima_ant CHAR(2) DEFAULT 'd')
    RETURNS CHAR(2)
    LANGUAGE plpgsql AS $$
    declare
        indice_clima SMALLINT;
    begin
        --Generar numero random (1- 10)
        indice_clima := gen_random(1, 10);

        --Segun clima anterior
        CASE clima_ant
            WHEN 'd' THEN
                -- 1 al 6 mantener Despejado
                if indice_clima >= 1 AND indice_clima <= 6 THEN
                    return 'd';
                end if;

                -- 7 al 10 => nublado
                if indice_clima >= 7 AND indice_clima <= 10 THEN
                    return 'n';
                end if;

            WHEN 'n' THEN
                --1 a; 4 => nublado
                 if indice_clima >= 1 AND indice_clima <= 4 THEN
                    return 'd';
                 end if;
                --5 al 7 => despejado
                if indice_clima >= 5 AND indice_clima <= 7 THEN
                    return 'd';
                end if;
                --8 al 10 => llover
                if indice_clima >= 8 AND indice_clima <= 10 THEN
                    return 'll';
                end if;

            WHEN 'll' THEN
                --1 al 5 => nublado
                if indice_clima >= 1 AND indice_clima <= 5 THEN
                    return 'n';
                end if;
                --6 al 10 => lluvia
                if indice_clima >= 6 AND indice_clima <= 10 THEN
                    return 'll';
                end if;
        END CASE;
    end;
$$;


-- OBTENER LUZ SEGUN HORA DEL DIA
-- Ej: SELECT obt_nivel_luz(2::smallint, 12::SMALLINT) => D (medio dia)
CREATE OR REPLACE FUNCTION obt_nivel_luz(id_evento SMALLINT, hora_act SMALLINT)
    RETURNS CHAR(2) LANGUAGE plpgsql AS $$
    declare
        hora_inicial SMALLINT;
        hora_abs SMALLINT;
    begin
        SELECT EXTRACT(HOUR FROM e.fecha)::SMALLINT INTO hora_inicial FROM eventos AS e WHERE e.id_evento = obt_nivel_luz.id_evento;
        --Calculamos la hora absoluta actual: inicial+horas_pasadas
        hora_abs := (hora_inicial + hora_act) % 24;
        --Segun formato 24h
        if hora_abs >= 17 AND hora_abs <= 19 then
            -- Atardecer
            RETURN 'at';
        elsif (hora_abs >= 20 AND hora_abs <= 24) OR (hora_abs >= 0 AND hora_abs <= 4) then
            -- noche
            RETURN 'n';
        elsif hora_abs >= 5 AND hora_abs <= 7 then
            -- Amanecer
            RETURN 'am';
        else
            --Dia
            RETURN 'd';
        end if;
    end;
$$;


-- ESTIMAR TEMPERATURA PROMEDIO DE LA PISTA
-- Ej: SELECT estimar_temp_promedio_hora('n', 'll')
CREATE OR REPLACE FUNCTION estimar_temp_promedio_hora(luz CHAR(2), clima CHAR(2))
    RETURNS SMALLINT LANGUAGE plpgsql AS $$
    declare
    begin
        if (luz = 'n' AND clima = 'll') OR (luz = 'n' AND clima = 'n') OR (luz = 'n' AND clima = 'd') OR (luz = 'am' AND clima = 'll') OR (luz = 'am' AND clima = 'n') then
            -- 8°C - 17°C
            RETURN gen_random(8, 17);
        elsif (luz = 'd' AND clima = 'll') OR (luz = 'at' AND clima = 'd') OR (luz ='am' AND clima = 'd') OR (luz='at' AND clima='n') OR (luz = 'd' AND clima ='n') then
            -- 11°C - 22°C
            RETURN gen_random(11, 22);
        else
            -- 22°C - 33°C
             RETURN gen_random(22, 33);
        end if;
    end;
$$;

--FUNC obtener_estrategia_equipo_hora()
--Entrada: Equipo y Hora
--Salida: estrategia
--EJ: SELECT obtener_estrategia_equipo_hora(11::smallint, 1::smallint, 7::smallint,4)
CREATE OR REPLACE FUNCTION obtener_estrategia_equipo_hora (id_event SMALLINT, id_equipo_est SMALLINT, nro_equipo_est NUMERIC(3) ,hora_est NUMERIC(2)) 
RETURNS CHAR(1) AS $$
    DECLARE
        estrategia CHAR(1);
    BEGIN
            SELECT resumen_datos.tipo_estrategia INTO estrategia FROM resumen_datos 
                INNER JOIN sucesos s on resumen_datos.id_suceso = s.id_suceso and resumen_datos.id_suceso_evento = s.id_evento and resumen_datos.id_suceso_pista = s.id_event_pista
            WHERE resumen_datos.id_car_equipo = id_equipo_est AND s.hora = hora_est AND resumen_datos.car_nro_equipo = nro_equipo_est AND resumen_datos.id_suceso_evento = id_event;

        RETURN estrategia;
    END;
$$ LANGUAGE plpgsql;

--OBTENER Categoria vehiculo
--Entrada: Equipo(id y nro) y evento
--EJ: SELECT obtener_categoria_veh(1::smallint, 1::smallint, 9)
CREATE OR REPLACE FUNCTION obtener_categoria_veh(id_event SMALLINT, id_equipo_cat SMALLINT, nro_equipo_cat NUMERIC(3))
RETURNS CHAR(7) LANGUAGE plpgsql AS $$
    declare
        categoria CHAR(7);
    begin
        SELECT v.categoria INTO categoria FROM participaciones AS parti
            INNER JOIN vehiculos v on parti.id_vehiculo = v.id_vehiculo
        WHERE parti.id_evento = id_event AND parti.nro_equipo = nro_equipo_cat AND parti.id_equipo = id_equipo_cat;

        RETURN categoria;
    end;
$$;

-- FUNC obtener_clima_hora
--Entrada: Hora
--Salida: Clima
--Ej: SELECT obtener_clima_hora(11::smallint, 1)
CREATE OR REPLACE FUNCTION obtener_clima_hora (id_event SMALLINT, hora_suc NUMERIC(2)) RETURNS CHAR(2) AS $$
    DECLARE
                clima CHAR(2);
    BEGIN
            SELECT (s.metereologia).clima INTO clima FROM sucesos AS s WHERE s.id_evento = id_event AND s.hora = hora_suc;
        RETURN clima;
    END;
$$ LANGUAGE plpgsql;

-- FUNC obtener_temp_pista_hora
--Entrada: Hora
--Salida: Temperatura
--Ej: SELECT obtener_temp_pista_hora(11::smallint, 5)
CREATE OR REPLACE FUNCTION obtener_temp_pista_hora (id_event SMALLINT, hora_suc NUMERIC(2)) RETURNS NUMERIC(3) AS $$
    DECLARE
        temp NUMERIC(3);
    BEGIN
        SELECT (s.metereologia).temp_pista INTO temp FROM sucesos AS s WHERE s.id_evento = id_event AND s.hora = hora_suc;
        RETURN temp;
    END;
$$ LANGUAGE plpgsql;

--SIMULACION
--Se  especificará la pista a utilizar. (ID)
--Clima inicial en la hora 1. (D,N,LL)
--Fecha del evento y Hora de inicio (DATE)
--Año de referencia (Num ####)

-- (0) Crear evento
-- Ej call crear_evento(1::smallint, '18/12/2020 16:00:00'::timestamp)
CREATE OR REPLACE PROCEDURE crear_evento(id_pista SMALLINT, fecha_evento TIMESTAMP)
    LANGUAGE plpgsql AS $$
    declare
        id_event SMALLINT;
    begin
        --Creamos evento
        --Guardamos id del evento para uso posterior
        INSERT INTO eventos(id_pista, fecha) VALUES (id_pista, fecha_evento) RETURNING id_evento INTO id_event;
        commit;

        --Generamos 24 instancias de sucesos
        for hora in 1..24 loop
            INSERT INTO sucesos(id_evento, id_event_pista, hora) VALUES (id_event, id_pista, hora);
            commit;
        end loop;
    end;
$$;

-- (1) Generar clima por hora
-- Ej: call generar_clima(2::smallint, 'n');
CREATE OR REPLACE PROCEDURE generar_clima(id_evento SMALLINT, clima_inicial CHAR(2))
    LANGUAGE plpgsql AS $$
    declare
        clim_ant char(2);
    begin

     -- Recorrer cada hora del evento y predecir
        for suc_horas IN 1..24 loop
            --Establecemos prediccion y guardamos para proxima
           if suc_horas = 1 then
                -- 1era hora, establecer
                UPDATE sucesos AS s SET metereologia.clima = clima_inicial
                    WHERE s.id_evento = generar_clima.id_evento AND s.hora = suc_horas;
                commit;
                clim_ant := clima_inicial;
            else
                --Predecimos el clima segun anterior
                clim_ant := predecir_clima(clim_ant);
                UPDATE sucesos AS s SET metereologia.clima = clim_ant
                    WHERE s.id_evento = generar_clima.id_evento AND s.hora = suc_horas;
                commit;
            end if;
        end loop;
    end;
$$;

-- (3) GENERAR TEMP PISTA POR HORA
-- EJ: call generar_temp_pista_hora(2::smallint);
CREATE OR REPLACE PROCEDURE generar_temp_pista_hora(id_evento SMALLINT)
    LANGUAGE plpgsql AS $$
    declare
        aux_metereologia RECORD;
        clima_act metereologia;
        luz_act CHAR(2);
        temp_prom SMALLINT;
    begin
        for horas IN 1..24 loop
            --Obtenemos luz de la hora
            SELECT obt_nivel_luz(id_evento, horas::smallint) INTO luz_act;
            --Obtenemos clima de la hora (anteriormente generada)
            SELECT metereologia INTO aux_metereologia FROM sucesos AS s WHERE s.id_evento = generar_temp_pista_hora.id_evento AND s.hora = horas;
            clima_act := aux_metereologia.metereologia;

             -- Actualizamos/Guardamos temperatura generada
            temp_prom := estimar_temp_promedio_hora(luz_act, clima_act.clima);
             UPDATE sucesos AS s SET metereologia.temp_pista = temp_prom
                    WHERE s.id_evento = generar_temp_pista_hora.id_evento AND s.hora = horas;
             commit;
        end loop;
    end;
$$;

-- (4) GENERAR PARTICIPACIONES SEGUN ANNO DE REFERENCIA
-- EJ: call generar_participaciones(1::smallint, 1::smallint, 2005::smallint)
-- call generar_participaciones(1::smallint, 1::smallint, 2005::smallint);
CREATE OR REPLACE PROCEDURE generar_participaciones(id_evento_nuevo SMALLINT, id_pista_nuevo SMALLINT, ano_ref smallint)
    LANGUAGE plpgsql AS $$
    declare
        -- 1 Obtener evento id de referencia
        cur_parti_ref CURSOR FOR SELECT * FROM participaciones AS p WHERE p.id_evento = obt_evento_id(ano_ref);
        cur_plan_ref CURSOR FOR SELECT * FROM plantillas AS p WHERE p.id_parti_evento = obt_evento_id(ano_ref);
    begin
        -- 2 Obtener participaciones de evento old
        for parti_ref IN cur_parti_ref LOOP
            -- 2.1 Crear participaciones nuevas
            INSERT INTO participaciones VALUES (parti_ref.nro_equipo, parti_ref.id_vehiculo, parti_ref.id_equipo, id_evento_nuevo, id_pista_nuevo);
            commit;
        end loop;

        -- 3 Obtener plantilla de evento old
        for plan_ref IN cur_plan_ref LOOP
            -- 3.1 Crear plantilla nueva
            INSERT INTO plantillas VALUES (plan_ref.id_piloto, plan_ref.parti_nro_equipo, plan_ref.id_parti_vehiculo, plan_ref.id_parti_equipo, id_evento_nuevo, id_pista_nuevo);
            commit;
        end loop;
    end;
$$;

-- (5)Generar lotes de inventario para cada equipo
--Ej: call generar_lotes_inv(2)
CREATE OR REPLACE PROCEDURE generar_lotes_inv(id_evento SMALLINT)
    LANGUAGE plpgsql AS $$
    declare
        -- 1 Obtener equipos participantes
        cur_equipos CURSOR FOR SELECT p.id_equipo, p.nro_equipo FROM participaciones AS p WHERE p.id_evento = generar_lotes_inv.id_evento;
    begin
        for equipo IN cur_equipos loop
            -- 2 Generar lotes por cada equipo de cada item
            INSERT INTO lotes_repuestos(id_equipo, tipo_pieza, cant_disponible) VALUES (equipo.id_equipo, 'ne', 26);
            INSERT INTO lotes_repuestos(id_equipo, tipo_pieza, cant_disponible) VALUES (equipo.id_equipo, 'fr', 30);
            INSERT INTO lotes_repuestos(id_equipo, tipo_pieza, cant_disponible) VALUES (equipo.id_equipo, 'ac', 30);
            INSERT INTO lotes_repuestos(id_equipo, tipo_pieza, cant_disponible) VALUES (equipo.id_equipo, 'tr', 15);
            commit;
        end loop;
    end;
$$;

CREATE OR REPLACE PROCEDURE generar_ensayo(anno_viejo SMALLINT, anno_nuevo SMALLINT, id_pista SMALLINT)
    LANGUAGE plpgsql AS $$
    declare
        -- 1 Obtener evento id de referencia
        cur_ensayos CURSOR FOR SELECT * FROM ensayos AS e WHERE e.id_parti_evento = obt_evento_id(anno_viejo);
    begin
        -- 2 Guardar la información del ensayo
        for e IN cur_ensayos LOOP
            -- 2.1 Crear registros del ensayo
            INSERT INTO ensayos(parti_nro_equipo, id_parti_vehiculo, id_parti_equipo, id_parti_evento, id_parti_evento_pista, estadistica) VALUES (e.parti_nro_equipo,e.id_parti_vehiculo,e.id_parti_equipo,obt_evento_id(anno_nuevo),id_pista, ROW((e.estadistica).velocidad_media,(e.estadistica).tiempo_mejor_vuelta,(e.estadistica).puesto));
            commit;
        end loop;
    end;
$$;

-- (7) Generar participacion en carrera a los clasificados
--Ej: call  generar_clasificacion_carrera(15::smallint);
CREATE OR REPLACE PROCEDURE  generar_clasificacion_carrera(id_event SMALLINT) LANGUAGE plpgsql AS $$
    DECLARE
        --Seleccionamos los mejores 45
        cur_ensayo CURSOR FOR SELECT * FROM ensayos eny WHERE eny.id_parti_evento = id_event ORDER BY (eny.estadistica).puesto LIMIT 45;
    BEGIN
        for corredores IN cur_ensayo LOOP
            INSERT INTO carreras(parti_nro_equipo, id_parti_vehiculo, id_parti_equipo, id_parti_evento, id_parti_evento_pista, estado)
                VALUES (corredores.parti_nro_equipo, corredores.id_parti_vehiculo, corredores.id_parti_equipo, id_event, corredores.id_parti_evento_pista, 'c');
            commit;
        end loop;
    END;
$$;


--(8) Generar estrategia
--1 Generar las 24h resumen de datos
--1.1 Generar estrategia por hora
--Ej: call generar_estrategia(11::smallint);
CREATE OR REPLACE PROCEDURE generar_estrategia (id_evento SMALLINT) LANGUAGE plpgsql AS $$
    DECLARE
			estrategia INTEGER;
      aux_id_suceso SMALLINT;
      cur_carrera CURSOR FOR SELECT * FROM carreras AS car WHERE car.id_parti_evento = generar_estrategia.id_evento;
    BEGIN
    for clas_car IN cur_carrera loop
    	--1 Generar las 24h resumen de datos
        for hora1 in 1..24 loop
              --Obtenemos suceso relacionado al evento y hora
              SELECT s.id_suceso INTO aux_id_suceso FROM sucesos AS s WHERE s.id_evento = generar_estrategia.id_evento AND s.hora = hora1;
              --Obtenemos datos de carrera
              --SELECT * INTO aux_carrera FROM carreras AS car WHERE car.id_parti_evento = generar_estrategia.id_evento AND car.id_parti_evento_pista = generar_estrategia.id_pista_evt AND car.id_parti_equipo = generar_estrategia.id_equipo;

              -- Generar estrategia por cada equipo
              if (hora1 = 1) THEN
                  --1.1* Hora 1 (todos estrategia agresiva)
                  INSERT INTO resumen_datos(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista,nro_vueltas, estadistica, tipo_estrategia) VALUES (aux_id_suceso, id_evento, clas_car.id_parti_evento_pista, clas_car.id_carrera, clas_car.parti_nro_equipo, clas_car.id_parti_vehiculo,clas_car.id_parti_equipo, id_evento, clas_car.id_parti_evento_pista,0, (0,'0:00.0',0), 'a');
                  commit;
              else
                   estrategia := gen_random(1,10);
                  if(estrategia >= 1 and estrategia <= 4) THEN
                      --  Generar estrategia tipo agresivo por cada equipo
                      INSERT INTO resumen_datos(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista,nro_vueltas, estadistica, tipo_estrategia) VALUES (aux_id_suceso, id_evento, clas_car.id_parti_evento_pista, clas_car.id_carrera, clas_car.parti_nro_equipo, clas_car.id_parti_vehiculo,clas_car.id_parti_equipo, id_evento, clas_car.id_parti_evento_pista,0, (0,'0:00.0',0), 'a');
                  		commit;
                  elseif (estrategia >=5 and estrategia <=7) THEN
                      --  Generar estrategia tipo intermedio por cada equipo
                       INSERT INTO resumen_datos(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista,nro_vueltas, estadistica, tipo_estrategia) VALUES (aux_id_suceso, id_evento, clas_car.id_parti_evento_pista, clas_car.id_carrera, clas_car.parti_nro_equipo, clas_car.id_parti_vehiculo,clas_car.id_parti_equipo, id_evento, clas_car.id_parti_evento_pista,0, (0,'0:00.0',0), 'i');
                  		 commit;
                  elseif (estrategia >=8 and estrategia<=10) THEN
                      --  Generar estrategia tipo conservador por cada equipo
                       INSERT INTO resumen_datos(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista,nro_vueltas, estadistica, tipo_estrategia) VALUES (aux_id_suceso, id_evento, clas_car.id_parti_evento_pista, clas_car.id_carrera, clas_car.parti_nro_equipo, clas_car.id_parti_vehiculo,clas_car.id_parti_equipo, id_evento, clas_car.id_parti_evento_pista,0, (0,'0:00.0',0), 'c');
                  		 commit;
                  end if;
              end if;
        end loop;
      end loop;
   END;
$$;

--CARRERA
--FUNCIONES INTERNAS

--GENERAR VELOCIDAD MEDIA A EQUIPO EN UNA HORA
--EJ: call generar_veloc_media(11::smallint, 1::smallint, 7, 1);
CREATE OR REPLACE PROCEDURE generar_veloc_media (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
    DECLARE
        vel_gen NUMERIC(5,2) := 175.00;
    aux_clima CHAR(2);
    aux_temp NUMERIC(3);
    aux_est CHAR(1);
    aux_cat CHAR(7); 
    aux_luz_dia CHAR(2);
    aux_id_suc SMALLINT;
    BEGIN
            
            --Estrategia en la hora
        aux_est := obtener_estrategia_equipo_hora(id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
            WHEN 'a' THEN
                vel_gen := vel_gen + 20;
            WHEN 'i' THEN
                vel_gen := vel_gen + 10;
            WHEN 'c' THEN
                vel_gen := vel_gen + 0;
        END CASE;
        
        --Clima en la hora
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
                WHEN 'd' THEN
                vel_gen := vel_gen + 15;
            WHEN 'll' THEN
                vel_gen := vel_gen - 10;
            WHEN 'n' THEN
                vel_gen := vel_gen + 8;
        END CASE;  
        
        --Nivel de luz
        aux_luz_dia := obt_nivel_luz(id_event, hora::smallint);
        CASE aux_luz_dia
        WHEN 'at' THEN
        WHEN 'am' THEN
            vel_gen := vel_gen - 5;
            
        WHEN 'n' THEN
            vel_gen := vel_gen + 5;
            
        WHEN 'd' THEN
            vel_gen := vel_gen + 8;
        END CASE;
        
        --Temperatura promedio de pista
        aux_temp := obtener_temp_pista_hora (id_event, hora);
        IF (aux_temp >=8 and aux_temp <=17) THEN
            vel_gen := vel_gen + 4;
        ELSIF (aux_temp >= 11 and aux_temp < 22) THEN
            vel_gen := vel_gen + 2;
        END IF;
        --Categoría de vehículo
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
        WHEN 'LM P675' THEN
            vel_gen := vel_gen + 5;
            
        WHEN 'LM GTP' THEN
        WHEN 'LM GTS' THEN
        WHEN 'LM GT' THEN
        WHEN 'LM GT1' THEN
        WHEN 'LM GT2' THEN
                vel_gen := vel_gen + 3;
            
        WHEN 'LM P1' THEN
        WHEN 'LM P2' THEN
            vel_gen := vel_gen + 1;
        END CASE;
        
        --Guardamos velocidad media generada
        aux_id_suc := obtener_suceso_id(id_event, hora);
        
        UPDATE resumen_datos AS rd SET estadistica.velocidad_media = vel_gen WHERE rd.id_suceso = aux_id_suc AND rd.id_suceso_evento = id_event AND rd.id_car_equipo = id_equipo AND rd.car_nro_equipo = nro_equipo;
        commit;
    END;
$$ LANGUAGE plpgsql;

--Generar mejor tiempo  en la hora 
--SELECT '04:00.0'::TIME + INTERVAL '2 seconds' => 00:04:02
--EJ: call generar_mejor_tiempo_hora(11::smallint, 1::smallint, 7, 1);
CREATE OR REPLACE PROCEDURE generar_mejor_tiempo_hora (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
    DECLARE
        time_gen TIME := '04:00.0';
    aux_clima CHAR(2);
    aux_temp NUMERIC(3);
    aux_est CHAR(1);
    aux_cat CHAR(7); 
    aux_luz_dia CHAR(2);
    aux_id_suc SMALLINT;
    BEGIN
            --Estrategia del equipo
        aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
        WHEN 'a' THEN
            time_gen := time_gen - INTERVAL '40 seconds';
        WHEN 'i' THEN
            time_gen := time_gen - INTERVAL '20 seconds';
        WHEN 'c' THEN
            time_gen := time_gen - INTERVAL '5 seconds';
        END CASE;
        
        --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            time_gen := time_gen - INTERVAL '5 seconds';
        WHEN 'll' THEN
            time_gen := time_gen + INTERVAL '10 seconds';
        WHEN 'n' THEN
            time_gen := time_gen + INTERVAL '0 seconds';
        END CASE;
        
        --Nivel de luz
        aux_luz_dia := obt_nivel_luz(id_event, hora::smallint);
        CASE aux_luz_dia
        WHEN 'at' THEN
        WHEN 'am' THEN
                time_gen := time_gen + INTERVAL '6 seconds';
        WHEN 'n' THEN
                time_gen := time_gen + INTERVAL '1 seconds';
        WHEN 'd' THEN
                    time_gen := time_gen - INTERVAL '2 seconds';
        END CASE;
        
        --Temperatura promedio de pista
        aux_temp := obtener_temp_pista_hora (id_event, hora);
        IF (aux_temp >= 8 AND aux_temp <=17) THEN
                time_gen := time_gen - INTERVAL '2 seconds';
        ELSIF (aux_temp > 17 AND aux_temp <= 22) THEN
                time_gen := time_gen + INTERVAL '1 seconds';
        ELSIF (aux_temp > 22 AND aux_temp <= 33) THEN
                time_gen := time_gen + INTERVAL '3 seconds';
        END IF;
        --Categoría de carro
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
            WHEN 'LM P675' THEN
                time_gen := time_gen - INTERVAL '4 seconds';
                
            WHEN 'LM GTP' THEN
            WHEN 'LM GTS' THEN
            WHEN 'LM GT' THEN
            WHEN 'LM GT1' THEN
            WHEN 'LM GT2' THEN
                time_gen := time_gen + INTERVAL '2 seconds';
                
            WHEN 'LM P1' THEN
            WHEN 'LM P2' THEN
            time_gen := time_gen - INTERVAL '1 seconds';
        END CASE;
        
        --Guardar tiempo generado
        aux_id_suc := obtener_suceso_id(id_event, hora);  
        UPDATE resumen_datos AS rd SET estadistica.tiempo_mejor_vuelta = time_gen WHERE rd.id_suceso = aux_id_suc AND rd.id_suceso_evento = id_event AND rd.id_car_equipo = id_equipo AND rd.car_nro_equipo = nro_equipo;
        commit;
    END;
$$ LANGUAGE plpgsql;

--VERIFICAR DISPONIIBLIDAD DE PIEZA
--EJ: select  verificar_disp_pieza(1::smallint, 'ne', 1)
CREATE OR REPLACE FUNCTION verificar_disp_pieza (id_equipo SMALLINT, pieza CHAR(2), cant_pz NUMERIC(1)) RETURNS BOOLEAN AS $$
  DECLARE
  	aux_disp INTEGER;
    aux_pieza CHAR(2);
  BEGIN
      --Ajustamos valor
      IF (pieza = 'pa' or pieza = 'fa') then
          aux_pieza := 'ac';
      else
          aux_pieza := pieza;
      end if;

      --Verificamos cantidad
  	  SELECT COUNT(lr.cod_lote) INTO aux_disp FROM lotes_repuestos AS lr WHERE lr.id_equipo = verificar_disp_pieza.id_equipo AND lr.cant_disponible >= cant_pz AND lr.tipo_pieza = aux_pieza;
      IF (aux_disp <> 0) THEN
      	--hay disponibilidad
        RETURN TRUE;
      else
      	--no hay
      	RETURN FALSE;
      END IF;
  END;
$$ LANGUAGE plpgsql;

--CAMBIAR STATUS DE CORREDOR
CREATE OR REPLACE PROCEDURE cambiar_status_equipo (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), nuevo_estado CHAR(2))
    LANGUAGE plpgsql AS $$
    begin
        UPDATE carreras SET estado = nuevo_estado WHERE id_parti_evento = id_event AND id_parti_equipo = id_equipo AND parti_nro_equipo = nro_equipo;
        commit;
    end;
$$;

--USAR PIEZA DE INVENTARIO
CREATE OR REPLACE PROCEDURE usar_pieza_inventario (id_equipo SMALLINT, pieza CHAR(2), cant_pz NUMERIC(1))
    LANGUAGE plpgsql AS $$
    declare
        aux_pieza CHAR(2);
    begin
        --Ajustamos valor
          IF (pieza = 'pa' or pieza = 'fa') then
              aux_pieza := 'ac';
          else
              aux_pieza := pieza;
          end if;

        raise notice 'Usando pieza % para el id equipo %', aux_pieza, id_equipo;

        UPDATE lotes_repuestos  SET cant_disponible = cant_disponible - cant_pz WHERE lotes_repuestos.id_equipo = usar_pieza_inventario.id_equipo AND lotes_repuestos.tipo_pieza = aux_pieza;
        commit;
    end;
$$;


--GENERAR INDICE DE ACCIDENTE
CREATE OR REPLACE FUNCTION generar_indice_accidente(id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2))
    RETURNS NUMERIC(2) LANGUAGE plpgsql AS $$
    DECLARE
        indice_accidente NUMERIC(2) := 0;
        aux_est CHAR(1);
        aux_clima CHAR(2);
        aux_luz_dia CHAR(2);
    BEGIN
        --Estrategia del equipo
        aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
        WHEN 'a' THEN
            indice_accidente := indice_accidente + 5;
        WHEN 'i' THEN
            indice_accidente := indice_accidente + 2;
        WHEN 'c' THEN
            indice_accidente := indice_accidente;
        END CASE;

        --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            indice_accidente := indice_accidente;
        WHEN 'll' THEN
            indice_accidente := indice_accidente + 5;
        WHEN 'n' THEN
            indice_accidente := indice_accidente + 1;
        END CASE;

        --Luz
         aux_luz_dia := obt_nivel_luz(id_event, hora::smallint);
        CASE aux_luz_dia
        WHEN 'at' THEN
        WHEN 'am' THEN
                indice_accidente := indice_accidente + 2;
        WHEN 'n' THEN
                indice_accidente := indice_accidente + 3;
        WHEN 'd' THEN
                indice_accidente := indice_accidente;
        END CASE;

       return indice_accidente;
    END;
$$;

-- GENERAR POSIBILE FALLA
--Ej: call generar_posible_falla(11::smallint, 1::smallint, 1::smallint, 9::smallint, 508::smallint, 1::smallint, 1);

CREATE OR REPLACE PROCEDURE generar_posible_falla (id_event SMALLINT, id_event_pista SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), id_equipo_carrera SMALLINT, id_equipo_veh SMALLINT,  hora NUMERIC(2))
    LANGUAGE plpgsql AS $$
    DECLARE
        indice_falla NUMERIC(2) := 0;
        aux_clima CHAR(2);
        aux_temp NUMERIC(3);
        aux_est CHAR(1);
        aux_cat CHAR(7);
        aux_luz_dia CHAR(2);
        aux_id_suc SMALLINT;
        aux_falla INT;
        disp BOOLEAN;
        aux_cant_pz NUMERIC(2) := 0;
        aux_pz CHAR(2);
        aux_ind_accidente NUMERIC(2);
        aux_tp_accidente CHAR(1);
        aux_id_falla SMALLINT;
    BEGIN
        --Temperatura de pista
        aux_temp := obtener_temp_pista_hora (id_event, hora);
        IF (aux_temp > 17 AND aux_temp <= 22) THEN
                indice_falla := indice_falla + 1;
        ELSIF (aux_temp > 22 AND aux_temp <= 33) THEN
                indice_falla := indice_falla + 5;
        END IF;

        --Estrategia del equipo
        aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
        WHEN 'a' THEN
            indice_falla := indice_falla + 4;
        WHEN 'i' THEN
            indice_falla := indice_falla + 2;
        WHEN 'c' THEN
            indice_falla := indice_falla;
        END CASE;

        --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            indice_falla := indice_falla;
        WHEN 'll' THEN
            indice_falla := indice_falla + 5;
        WHEN 'n' THEN
            indice_falla := indice_falla + 1;
        END CASE;

        --Categoría del vehículo del equipo
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
            WHEN 'LM P675' THEN
                indice_falla := indice_falla + 3;

            WHEN 'LM GTP' THEN
            WHEN 'LM GTS' THEN
            WHEN 'LM GT' THEN
            WHEN 'LM GT1' THEN
            WHEN 'LM GT2' THEN
                indice_falla := indice_falla + 4;

            WHEN 'LM P1' THEN
            WHEN 'LM P2' THEN
                indice_falla := indice_falla + 1;
        END CASE;

        raise notice 'Indice de falla: % para equipo % en la hora %', indice_falla, nro_equipo, hora;

        --Analisis del indice
        if (indice_falla >= 10 and indice_falla <= 16) then
        		aux_falla:= gen_random(1,6);
            --falla parcial
            --Registrar falla

           IF (aux_falla = 1) THEN
                --Falla de neumáticos
                aux_pz := 'ne';
                aux_cant_pz := 4;
            ELSIF (aux_falla = 2) THEN
                --Falla frenos
                aux_pz := 'fr';
                aux_cant_pz := 1;
            ELSIF (aux_falla = 3) THEN
             --Falla presión aceite
             		aux_pz := 'pa';
            ELSIF (aux_falla = 4) THEN
             --Falla transmisión
             		aux_pz := 'tr';
               	aux_cant_pz := 1;
           ELSIF (aux_falla = 5) THEN
             --Falla fuga aceite
             		aux_pz := 'fa';
                aux_cant_pz := 1;
            ELSIF (aux_falla = 6) THEN
             --Falla calibración neumáticos
                aux_pz := 'cn';
            END IF;
							--Notificamos falla
        			aux_id_suc := obtener_suceso_id(id_event, hora);
             INSERT INTO fallas(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, pieza, tipo_falla)
                        VALUES (aux_id_suc, id_event, id_event_pista, id_equipo_carrera, nro_equipo, id_equipo_veh, id_equipo, id_event, id_event_pista, aux_pz, 'p') RETURNING id_falla INTO aux_id_falla;

            --Generamos parada en pits por falla
            --call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'fa', aux_id_falla);

           --Registrar uso de pieza (*verificar disponibilidad => si no hay cambiar status)
           if (aux_falla = 1 or aux_falla = 2 or aux_falla = 4 or aux_falla = 5) then
           			 disp := verificar_disp_pieza (id_equipo, aux_pz , aux_cant_pz);
                 if(disp) then
                 		--hay disponibilidad => descontar
                    raise  notice 'Usar pieza de inventario';
                    call usar_pieza_inventario(id_equipo, aux_pz, aux_cant_pz);
                 else
                 	--no hay disponibilidad => cambiar status = abandono
                     raise  notice 'cambiar_status_equipo por NO HAY disponibilidad';
                    call cambiar_status_equipo(id_event, id_equipo, nro_equipo, 'a');
                 end if;
           end if;

        elsif (indice_falla >= 17 and indice_falla <= 20) then
        		aux_falla:= gen_random(1,6);
            --falla total
            --Abandona carrera
        	raise  notice 'cambiar_status_equipo por FALLA TOTAL';
            call cambiar_status_equipo(id_event, id_equipo, nro_equipo, 'a');

            --Registrar pieza
            IF (aux_falla = 1) THEN
                --Insertar falla de neumáticos
                aux_pz := 'cc';
            ELSIF (aux_falla = 2) THEN
                --Insertar falla frenos
                aux_pz := 'tg';
            ELSIF (aux_falla = 3) THEN
             --Insertar falla presión aceite
                aux_pz := 'mt';
            ELSIF (aux_falla = 4) THEN
             --Insertar falla transmisión
                aux_pz := 'fg';
            ELSIF (aux_falla = 5) THEN
             --Insertar falla fuga aceite
                aux_pz := 'fe';
            ELSIF(aux_falla = 6) THEN
             --Insertar falla calibración neumáticos
             	aux_pz := 'sc';
             END IF;
                aux_id_suc := obtener_suceso_id(id_event, hora);
        			INSERT INTO fallas(id_suceso, id_suceso_evento, id_suceso_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, pieza, tipo_falla)
                        VALUES (aux_id_suc, id_event, id_event_pista, id_equipo_carrera, nro_equipo, id_equipo_veh, id_equipo, id_event, id_event_pista, aux_pz, 't') RETURNING id_falla INTO aux_id_falla;
            --call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'fa', aux_id_falla);
            --Obtener prob de accidente indv o colectivo
           	aux_ind_accidente := generar_indice_accidente(id_event, id_equipo, nro_equipo, hora);
            if (aux_ind_accidente >= 0 AND aux_ind_accidente <= 9) then
          		--accidente individual
              aux_tp_accidente := 'i';
            else
            	--accidente colectivo
              aux_tp_accidente := 'c';
            end if;

        	--Reportamos incidente (accidente)
           	aux_id_suc := obtener_suceso_id(id_event, hora);
        	INSERT INTO accidentes (id_falla, id_falla_suceso, id_falla_evento, id_falla_pista, id_falla_carrera, falla_nro_equipo, id_falla_vehiculo, id_falla_equipo, id_falla_car_evento, id_falla_car_pista, id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista, tipo)
           								VALUES (aux_id_falla, aux_id_suc, id_event, id_event_pista, id_equipo_carrera, nro_equipo, id_equipo_veh, id_equipo, id_event, id_event_pista, id_equipo_carrera, nro_equipo, id_equipo_veh, id_equipo, id_event, id_event_pista, aux_id_suc, id_event, id_event_pista, aux_tp_accidente);
        end if;
    END;
$$;

--GENERAR PARADA EN PITS general
--Ej: call generar_parada_pits(11::smallint, 2, 1::smallint, 7, 'cp',0::smallint ,1::smallint);
CREATE OR REPLACE PROCEDURE generar_parada_pits (id_event SMALLINT, hora NUMERIC(2), id_equipo SMALLINT, nro_equipo NUMERIC(3), motivo_parada CHAR(2), id_falla_parada SMALLINT DEFAULT 0, id_piloto_parada SMALLINT DEFAULT 0) AS $$
  DECLARE
  		aux_car_datos carreras%Rowtype;
      aux_id_suces SMALLINT;
      
  BEGIN
  		--Nos traemos los datos de la carrera
      SELECT * INTO aux_car_datos FROM carreras AS car WHERE car.id_parti_evento = id_event AND car.id_parti_equipo = id_equipo AND car.parti_nro_equipo = nro_equipo;
      --Solicitamos id suceso
      aux_id_suces := obtener_suceso_id(id_event, hora);
      
  		if(id_falla_parada = 0 and id_piloto_parada = 0) then
      	--Generar una parada CARRERA, SUCESOS sin falla ni piloto cambia
          INSERT INTO parada_pits ( id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista, motivo) 
          												VALUES (aux_car_datos.id_carrera, nro_equipo, aux_car_datos.id_parti_vehiculo, id_equipo, id_event, aux_car_datos.id_parti_evento_pista, aux_id_suces, id_event, aux_car_datos.id_parti_evento_pista, motivo_parada);
      		commit;
      elsif(id_piloto_parada = 0)  then
      	 --Generar una parada CARRERA, SUCESOS con falla	
         INSERT INTO parada_pits ( id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista, id_falla, id_falla_suceso, id_falla_s_evento, id_falla_s_pista, id_falla_carrera, falla_nro_equipo, id_falla_vehiculo, id_falla_equipo, id_falla_evento, id_falla_pista, motivo) 
         													VALUES (aux_car_datos.id_carrera, nro_equipo, aux_car_datos.id_parti_vehiculo, id_equipo, id_event, aux_car_datos.id_parti_evento_pista, aux_id_suces, id_event, aux_car_datos.id_parti_evento_pista, id_falla_parada, aux_id_suces, id_event,  aux_car_datos.id_parti_evento_pista, aux_car_datos.id_carrera, nro_equipo, aux_car_datos.id_parti_vehiculo, id_equipo, id_event,  aux_car_datos.id_parti_evento_pista, motivo_parada);
      		commit;
      else
      	--Generar una parada CARRERA, SUCESOS con piloto
        INSERT INTO parada_pits ( id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista, id_piloto ,motivo) 
          												VALUES (aux_car_datos.id_carrera, nro_equipo, aux_car_datos.id_parti_vehiculo, id_equipo, id_event, aux_car_datos.id_parti_evento_pista, aux_id_suces, id_event, aux_car_datos.id_parti_evento_pista, id_piloto_parada, motivo_parada);
        commit;
      end if;
  END;
$$ LANGUAGE plpgsql;

--VERIFICAR ACCIDENTE COLECTIVO
--Ej: SELECT verificar_accidente_colectivo(11::smallint, 1, 1::smallint, 8);
CREATE OR REPLACE PROCEDURE verificar_accidente_colectivo (id_event SMALLINT, hora NUMERIC(2), id_equipo SMALLINT, nro_equipo NUMERIC(3))  AS $$
  DECLARE
        aux_cant_acc NUMERIC(2) := 0;
        aux_clima CHAR(2);
        aux_est CHAR(1);
        aux_luz_dia CHAR(2);
        aux_ind_involucramiento NUMERIC(2) := 0;
  BEGIN
  		SELECT COUNT(*) INTO aux_cant_acc FROM accidentes AS acc WHERE acc.car_nro_equipo <> nro_equipo AND acc.id_car_evento = id_event AND acc.tipo = 'c';

        if(aux_cant_acc <> 0) then
        --hay accidentes colectivos
		--Estrategia del equipo
          aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
          CASE aux_est
            WHEN 'a' THEN
                aux_ind_involucramiento := aux_ind_involucramiento + 4;
            WHEN 'i' THEN
                aux_ind_involucramiento := aux_ind_involucramiento + 2;
            WHEN 'c' THEN
                aux_ind_involucramiento := aux_ind_involucramiento;
          END CASE;

          --Clima
          aux_clima := obtener_clima_hora(id_event, hora);
        	CASE aux_clima
            WHEN 'd' THEN
              aux_ind_involucramiento := aux_ind_involucramiento;
            WHEN 'll' THEN
              aux_ind_involucramiento := aux_ind_involucramiento + 3;
            WHEN 'n' THEN
              aux_ind_involucramiento := aux_ind_involucramiento + 1;
        	END CASE;

          --Nivel de luz
           aux_luz_dia := obt_nivel_luz(id_event, hora::smallint);
          CASE aux_luz_dia
            WHEN 'at' THEN
            WHEN 'am' THEN
                    aux_ind_involucramiento := aux_ind_involucramiento + 2;
            WHEN 'n' THEN
                    aux_ind_involucramiento := aux_ind_involucramiento + 3;
            WHEN 'd' THEN
                    aux_ind_involucramiento := aux_ind_involucramiento;
          END CASE;

          --Verificar involucramiento
          if (aux_ind_involucramiento >= 9 AND aux_ind_involucramiento <=10) then
          		--Si se involucra
          	    call cambiar_status_equipo (id_event, id_equipo, nro_equipo, 'a');
                call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ad');
          end if;
        end if;
  END;
$$ LANGUAGE plpgsql;

-- Generar paradas en pits por motivo gasolina
--Ej: call generar_paradas_gasolina(11::smallint, 1::smallint, 9::smallint, 5);
CREATE OR REPLACE PROCEDURE generar_paradas_gasolina(id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
  DECLARE
      aux_clima CHAR(2);
      aux_est CHAR(1);
      aux_cat CHAR(7);
      aux_ind_gas NUMERIC(2) := 0;
  BEGIN
  		--Estrategia del equipo
  		 aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
          CASE aux_est
            WHEN 'a' THEN
                aux_ind_gas := aux_ind_gas + 3;
            WHEN 'i' THEN
                aux_ind_gas := aux_ind_gas + 2;
            WHEN 'c' THEN
                aux_ind_gas := aux_ind_gas + 1;
          END CASE;

      --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            aux_ind_gas := aux_ind_gas + 2;
        WHEN 'll' THEN
            aux_ind_gas := aux_ind_gas;
        WHEN 'n' THEN
            aux_ind_gas := aux_ind_gas + 1;
        END CASE;

      --Categoría de carro
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
            WHEN 'LM P675' THEN
                aux_ind_gas := aux_ind_gas + 1;

            WHEN 'LM GTP' THEN
            WHEN 'LM GTS' THEN
            WHEN 'LM GT' THEN
            WHEN 'LM GT1' THEN
            WHEN 'LM GT2' THEN
                aux_ind_gas := aux_ind_gas + 3;

            WHEN 'LM P1' THEN
            WHEN 'LM P2' THEN
            		aux_ind_gas := aux_ind_gas + 2;
        END CASE;

        --Generar paradas
        if (aux_ind_gas >= 0 and aux_ind_gas <= 5) then
        		--1 parada
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
        elsif (aux_ind_gas >= 6 and aux_ind_gas <= 8) then
        		--2 paradas
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
        else
        		--3 paradas
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ga');
        end if;
  END;
$$ LANGUAGE plpgsql;

-- Generar paradas en pits por motivo neumatico
--Ej: call generar_paradas_neumatico(11::smallint, 1::smallint, 9, 2);
CREATE OR REPLACE PROCEDURE generar_paradas_neumatico(id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
  DECLARE
      aux_clima CHAR(2);
      aux_est CHAR(1);
      aux_temp NUMERIC(3);
      aux_cat CHAR(7);
      aux_ind_neumatico NUMERIC(2) := 0;
  BEGIN
  		--Estrategia del equipo
  		 aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
          CASE aux_est
            WHEN 'a' THEN
                aux_ind_neumatico := aux_ind_neumatico + 3;
            WHEN 'i' THEN
                aux_ind_neumatico := aux_ind_neumatico + 2;
            WHEN 'c' THEN
                aux_ind_neumatico := aux_ind_neumatico + 1;
          END CASE;

      --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            aux_ind_neumatico := aux_ind_neumatico + 2;
        WHEN 'll' THEN
            aux_ind_neumatico := aux_ind_neumatico + 1;
        WHEN 'n' THEN
            aux_ind_neumatico := aux_ind_neumatico + 1;
        END CASE;

			--Temperatura promedio de pista
      aux_temp := obtener_temp_pista_hora (id_event, hora);
        IF (aux_temp >= 8 and aux_temp <= 17) THEN
            aux_ind_neumatico := aux_ind_neumatico + 1;
        ELSIF (aux_temp >= 11 and aux_temp < 22) THEN
            aux_ind_neumatico := aux_ind_neumatico + 2;
        else
        		aux_ind_neumatico := aux_ind_neumatico + 3;
        END IF;

      --Categoría de carro
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
            WHEN 'LM P675' THEN
                aux_ind_neumatico := aux_ind_neumatico + 2;

            WHEN 'LM GTP' THEN
            WHEN 'LM GTS' THEN
            WHEN 'LM GT' THEN
            WHEN 'LM GT1' THEN
            WHEN 'LM GT2' THEN
                aux_ind_neumatico := aux_ind_neumatico + 3;

            WHEN 'LM P1' THEN
            WHEN 'LM P2' THEN
            		aux_ind_neumatico := aux_ind_neumatico + 1;
        END CASE;

        --Generar paradas
        if (aux_ind_neumatico >= 0 and aux_ind_neumatico <= 5) then
        		--1 parada
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
        elsif (aux_ind_neumatico >= 6 and aux_ind_neumatico <= 8) then
        		--2 paradas
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
        else
        		--3 paradas
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
            call generar_parada_pits (id_event, hora, id_equipo, nro_equipo, 'ne');
        end if;
  END;
$$ LANGUAGE plpgsql;

--Generar paradas en pits por motivo de cambio de conductor 
--Ej: call generar_paradas_conductor(1::smallint, 1::smallint, 7,2);
CREATE OR REPLACE PROCEDURE generar_paradas_conductor (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
    DECLARE
            rec_piloto record;
    BEGIN
        --Obtenemos el piloto con menos cambios en pits
        SELECT plant.id_piloto id_pilot, COUNT(plant.id_piloto) cant INTO rec_piloto FROM plantillas AS plant
                LEFT JOIN parada_pits pp on plant.id_piloto = pp.id_piloto
        WHERE plant.id_parti_evento = id_event AND plant.parti_nro_equipo = nro_equipo GROUP BY plant.id_piloto ORDER BY cant LIMIT 1;
        
        --Registramos cambio
        call generar_parada_pits(id_event, hora, id_equipo, nro_equipo, 'cp'::char(2), 0::smallint, rec_piloto.id_pilot);
    END;
$$ LANGUAGE plpgsql;

-- Generar Nro Vueltas por equipo en esa hora
--Ej: call generar_nro_vueltas(11::smallint, 1::smallint, 7, 3);
CREATE OR REPLACE PROCEDURE generar_nro_vueltas (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
  DECLARE
  			aux_clima CHAR(2);
      	aux_est CHAR(1);
        aux_cant_paradas NUMERIC(2) :=0;
        aux_cat CHAR(7);
        aux_nro_vueltas SMALLINT := 5;
        aux_suc SMALLINT;
        aux_is_acc NUMERIC(2) := 0;
  BEGIN
  		--Categoría del vehículo del equipo
        aux_cat := obtener_categoria_veh(id_event, id_equipo, nro_equipo);
        CASE aux_cat
            WHEN 'LMP 900' THEN
            WHEN 'LM P675' THEN
                aux_nro_vueltas := aux_nro_vueltas + 2;

            WHEN 'LM GTP' THEN
            WHEN 'LM GTS' THEN
            WHEN 'LM GT' THEN
            WHEN 'LM GT1' THEN
            WHEN 'LM GT2' THEN
                aux_nro_vueltas := aux_nro_vueltas + 3;

            WHEN 'LM P1' THEN
            WHEN 'LM P2' THEN
                aux_nro_vueltas := aux_nro_vueltas + 1;
        END CASE;
        
        --Clima
        aux_clima := obtener_clima_hora(id_event, hora);
        CASE aux_clima
        WHEN 'd' THEN
            aux_nro_vueltas := aux_nro_vueltas + 4;
        WHEN 'll' THEN
            aux_nro_vueltas := aux_nro_vueltas - 2;
        WHEN 'n' THEN
            aux_nro_vueltas := aux_nro_vueltas + 2;
        END CASE;
        
        --Estrategia del equipo
        aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
          WHEN 'a' THEN
              aux_nro_vueltas := aux_nro_vueltas + 3;
          WHEN 'i' THEN
              aux_nro_vueltas := aux_nro_vueltas + 2;
          WHEN 'c' THEN
              aux_nro_vueltas := aux_nro_vueltas - 2;
        END CASE;
        
        --Cantidad de paradas en pits
        aux_suc := obtener_suceso_id(id_event, hora);
        SELECT COUNT(pp.motivo) INTO aux_cant_paradas FROM parada_pits pp WHERE pp.car_nro_equipo = nro_equipo AND pp.id_car_evento = id_event AND pp.id_suceso = aux_suc;
        if(aux_cant_paradas <= 2) then
        		aux_nro_vueltas := aux_nro_vueltas - 1;
        elsif (aux_cant_paradas <= 4) then
        		aux_nro_vueltas := aux_nro_vueltas - 2;
        else
        		aux_nro_vueltas := aux_nro_vueltas - 3;
        end if;
        
        --Accidente individual del equipo
        SELECT COUNT(acc.id_suceso) INTO aux_is_acc FROM accidentes acc WHERE acc.id_suceso = aux_suc AND acc.car_nro_equipo = nro_equipo AND acc.id_car_evento = id_event AND acc.tipo = 'i';
        if(aux_is_acc <> 0) then
        		aux_nro_vueltas := aux_nro_vueltas - 4;
        end if;
        
        --Actualizamos
        --Validamos que no sea negativo
        if(aux_nro_vueltas < 0) then
        	aux_nro_vueltas := 0;
        end if;
        UPDATE resumen_datos SET nro_vueltas = aux_nro_vueltas WHERE id_car_evento = id_event AND id_suceso = aux_suc AND id_car_equipo = id_equipo AND car_nro_equipo = nro_equipo;
        commit;
  END;
$$ LANGUAGE plpgsql;


--Genera promedio temperatura del cockpit en esa hora
--Ej: call generar_temp_prom_cockpit(11::smallint, 1::smallint, 7, 5);
CREATE OR REPLACE PROCEDURE generar_temp_prom_cockpit (id_event SMALLINT, id_equipo SMALLINT, nro_equipo NUMERIC(3), hora NUMERIC(2)) AS $$
  DECLARE
  			aux_est CHAR(1);
        aux_luz_dia CHAR(2);
        aux_nro_vueltas NUMERIC(2) := 0;
        aux_clima CHAR(2);
        aux_temp_cock NUMERIC(2) := 18;
        aux_suc SMALLINT;
  BEGIN
  	 --Estrategia del equipo
        aux_est := obtener_estrategia_equipo_hora (id_event, id_equipo, nro_equipo, hora);
        CASE aux_est
        WHEN 'a' THEN
            aux_temp_cock := aux_temp_cock + 4;
        WHEN 'i' THEN
            aux_temp_cock := aux_temp_cock + 2;
        WHEN 'c' THEN
            aux_temp_cock := aux_temp_cock - 1;
        END CASE;

        --Nivel de luz
           aux_luz_dia := obt_nivel_luz(id_event, hora::smallint);
          CASE aux_luz_dia
            WHEN 'at' THEN
            WHEN 'am' THEN
                    aux_temp_cock := aux_temp_cock + 1;
            WHEN 'n' THEN
                    aux_temp_cock := aux_temp_cock - 4;
            WHEN 'd' THEN
                    aux_temp_cock := aux_temp_cock + 3;
          END CASE;

          --Nro vueltas realizadas
          aux_suc := obtener_suceso_id(id_event, hora);
          SELECT rd.nro_vueltas INTO aux_nro_vueltas FROM resumen_datos AS rd WHERE rd.id_car_evento = id_event AND rd.car_nro_equipo = nro_equipo AND rd.id_car_equipo = id_equipo AND rd.id_suceso = aux_suc;
          if (aux_nro_vueltas <= 10) then
          		aux_temp_cock := aux_temp_cock + 2;
          elsif (aux_temp_cock >= 11 and aux_temp_cock <= 16) then
          		aux_temp_cock := aux_temp_cock + 3;
          else
          		aux_temp_cock := aux_temp_cock + 4;
          end if;

        --Clima
            aux_clima := obtener_clima_hora(id_event, hora);
            CASE aux_clima
            WHEN 'd' THEN
                aux_temp_cock := aux_temp_cock + 2;
            WHEN 'll' THEN
                aux_temp_cock := aux_temp_cock - 3;
            WHEN 'n' THEN
                aux_temp_cock := aux_temp_cock - 1;
            END CASE;

          --Actualizamos temp
          UPDATE resumen_datos SET temp_cockpit = aux_temp_cock WHERE id_car_evento = id_event AND id_suceso = aux_suc AND id_car_equipo = id_equipo AND car_nro_equipo = nro_equipo;
          commit;
  END;
$$ LANGUAGE plpgsql;


--(10) Generar clasificación de los participantes
--Generar clasificación de los participantes
--Ej: call clasificacion_final_car(11::smallint);
CREATE OR REPLACE PROCEDURE clasificacion_final_car (id_event SMALLINT) AS $$
    DECLARE
        cur_clasificacion CURSOR FOR SELECT rd.car_nro_equipo, SUM(rd.nro_vueltas) total_vueltas, AVG((rd.estadistica).tiempo_mejor_vuelta) avg_tiempo FROM resumen_datos AS rd WHERE rd.id_suceso_evento = id_event GROUP BY rd.car_nro_equipo ORDER BY total_vueltas DESC, avg_tiempo ASC;
        aux_puesto NUMERIC(2) := 1;
        aux_suc SMALLINT;
    BEGIN
  		FOR clas_equipo IN cur_clasificacion LOOP
  		    aux_suc := obtener_suceso_id(id_event,24);

  		    --Actualizamos posiciones en hora 24 y puesto_final
            UPDATE resumen_datos SET estadistica.puesto = aux_puesto WHERE id_car_evento = id_event AND id_suceso = aux_suc  AND car_nro_equipo = clas_equipo.car_nro_equipo;
            UPDATE carreras SET puesto_final = aux_puesto WHERE id_parti_evento = id_event AND parti_nro_equipo = clas_equipo.car_nro_equipo;

            --Incrementamos contador
  		    aux_puesto := aux_puesto + 1;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;

--*****************************************************************************************************
--Trigger Aviso para reportar por falla una para en los pits
CREATE OR REPLACE FUNCTION trig_val_falla() RETURNS TRIGGER AS $$
    BEGIN
        IF ((NEW.id_falla) IS NOT NULL) THEN
           INSERT INTO parada_pits (id_carrera, car_nro_equipo, id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista, id_falla, id_falla_suceso, id_falla_s_evento, id_falla_s_pista, id_falla_carrera, falla_nro_equipo, id_falla_vehiculo, id_falla_equipo, id_falla_evento, id_falla_pista, motivo)
                        VALUES (NEW.id_carrera, NEW.car_nro_equipo, NEW.id_car_vehiculo, NEW.id_car_equipo, NEW.id_car_evento, NEW.id_car_pista, NEW.id_suceso, NEW.id_suceso_evento, NEW.id_suceso_pista, NEW.id_falla, NEW.id_suceso, NEW.id_suceso_evento, NEW.id_suceso_pista, NEW.id_carrera,NEW.car_nro_equipo, NEW.id_car_vehiculo, NEW.id_car_equipo,NEW.id_car_evento, NEW.id_suceso_pista, 'fa');
        END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
CREATE trigger trig_falla_parada AFTER INSERT ON fallas FOR EACH ROW EXECUTE PROCEDURE trig_val_falla();