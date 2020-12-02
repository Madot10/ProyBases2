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
-- FALTA PROBAR
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


call generar_participaciones(1::smallint, 1::smallint, 2005::smallint);


-- (5)Generar lotes de inventario para cada equipo
--Ej: call generar_lotes_inv(2)
-- FALTA PROBAR
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

