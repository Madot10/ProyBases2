CREATE OR REPLACE PROCEDURE simulacion_le_mans(id_pista SMALLINT, f_evento TIMESTAMP, ano_ref SMALLINT, clima_inicial CHAR(2)) AS $$
    DECLARE
        aux_id_evento SMALLINT;
        aux_anno_nuevo SMALLINT;
    BEGIN
        aux_anno_nuevo := EXTRACT(YEAR FROM f_evento)::SMALLINT;
        -- Borramos todo dato anterior
        call borrar_simulacion(aux_anno_nuevo);

        -- (0) Crear evento
        call crear_evento(id_pista, f_evento);
        aux_id_evento := obt_evento_id( aux_anno_nuevo);

        -- (1) Generar clima por hora
        call generar_clima(aux_id_evento, clima_inicial );

        -- (3) GENERAR TEMP PISTA POR HORA
         call generar_temp_pista_hora(aux_id_evento);

        -- (4) GENERAR PARTICIPACIONES SEGUN ANNO DE REFERENCIA
        call generar_participaciones(aux_id_evento, id_pista, ano_ref);

        -- (5) Generar lotes de inventario para cada equipo
        call generar_lotes_inv(aux_id_evento);

        -- (6) Generar ensayo
        call  generar_ensayo(ano_ref, aux_anno_nuevo, id_pista);

        -- (7) Generar participacion en carrera a los clasificados
        call generar_clasificacion_carrera(aux_id_evento);

        --(8) Generar estrategia
        call generar_estrategia (aux_id_evento);

        --SIMULACION CARRERA
        call simulacion_ciclo_carrera(aux_id_evento);

        --(10) Generar clasificación de los participantes
        call clasificacion_final_car (aux_id_evento);
    END;
$$ LANGUAGE plpgsql;