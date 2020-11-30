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
-- Ej: select obt_evento_id('2020-12-18 16:00:00'); => 2
CREATE OR REPLACE FUNCTION obt_evento_id(fecha DATE)
    RETURNS SMALLINT LANGUAGE plpgsql AS $$
    declare
        id_obt SMALLINT;
    begin
        SELECT e.id_evento INTO id_obt FROM eventos AS e WHERE e.fecha = obt_evento_id.fecha;
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

--SIMULACION
--Se  especificará la pista a utilizar. (ID)
--Clima inicial en la hora 1. (D,N,LL)
--Fecha del evento y Hora de inicio (DATE)
--Año de referencia (Num ####)

-- (0) Crear evento
-- Ej call crear_evento(1::smallint, '18/12/2020 16:00:00'::date)
CREATE OR REPLACE PROCEDURE crear_evento(id_pista SMALLINT, fecha_evento DATE)
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
