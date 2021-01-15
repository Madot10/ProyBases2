--creación de usuarios
CREATE USER dev LOGIN PASSWORD '12345';
CREATE USER analista1 LOGIN PASSWORD '12345';
CREATE USER analista2 LOGIN PASSWORD '12345';
CREATE USER analista3 LOGIN PASSWORD '12345';

--creación de roles
CREATE ROLE desarrollador SUPERUSER CREATEROLE;
CREATE ROLE analista_negocios_1;
CREATE ROLE analista_negocios_2;
CREATE ROLE analista_negocios_3;

--Asociar roles a usuarios
GRANT desarrollador TO dev;
GRANT analista_negocios_1 to analista1;
GRANT analista_negocios_2 to analista2;
GRANT analista_negocios_3 to analista3;

--definir roles
--rol analista 1
GRANT SELECT ON TABLE dim_equipo TO analista_negocios_1;
GRANT SELECT ON TABLE dim_piloto TO analista_negocios_1;
GRANT SELECT ON TABLE dim_tiempo TO analista_negocios_1;
GRANT SELECT ON TABLE dim_vehiculo TO analista_negocios_1;
GRANT SELECT ON TABLE ft_participacion TO analista_negocios_1;

--rol analista 2
--Al analista2 se le da el rol de analista_negocios_1 para que pueda acceder a las tablas
--que son requeridas por las funciones
GRANT analista_negocios_1 to analista2;
--Reporte 4
--SELECT * FROM reporte_rank_nro_equipo(1::SMALLINT, 2000);
GRANT EXECUTE ON FUNCTION reporte_rank_nro_equipo(NUMERIC,NUMERIC) TO analista_negocios_2;
--Reporte 5.1
GRANT EXECUTE ON FUNCTION reporte_logros_piloto(SMALLINT) TO analista_negocios_2;
--Reporte 5.2
GRANT EXECUTE ON FUNCTION reporte_datos_participacion(SMALLINT) TO analista_negocios_2;
--Reporte 6
GRANT EXECUTE ON FUNCTION reporte_participaciones_marcas_modelos(VARCHAR(30),VARCHAR(30)) TO analista_negocios_2;
--Reporte 7
GRANT EXECUTE ON FUNCTION reporte_piloto_joven(SMALLINT) TO analista_negocios_2;
--Reporte 8
GRANT EXECUTE ON FUNCTION reporte_piloto_mayor(SMALLINT) TO analista_negocios_2;
--Reporte 9
GRANT EXECUTE ON FUNCTION reporte_pilotos_mayor_participaciones() TO analista_negocios_2;
--Reporte 10
GRANT EXECUTE ON FUNCTION reporte_ganador_primera_participacion(SMALLINT) TO analista_negocios_2;

--rol analista 3
GRANT analista_negocios_1 to analista3;
--Reporte 11
--SELECT * FROM reporte_top_vel_media('car', 2000::smallint);
GRANT EXECUTE ON FUNCTION reporte_top_vel_media(CHAR(3),SMALLINT) TO analista_negocios_3;
--Reporte 12
GRANT EXECUTE ON FUNCTION reporte_distancias_mas_largas(NUMERIC(3)) TO analista_negocios_3;
--Reporte 13
--GRANT EXECUTE ON FUNCTION reporte_pilotos_podiums() TO analista_negocios_3;
--Reporte 14
--GRANT EXECUTE ON FUNCTION reporte_pilotos_nunca_meta() TO analista_negocios_3;
--Reporte 15
--Falta
--Reporte 16
--GRANT EXECUTE ON FUNCTION reporte_mujeres_pilotos(smallint) TO analista_negocios_3;

--rol desarrollador



--probando
select * from dim_tiempo;
--insert into eventos(id_pista, fecha) VALUES (1, '01-01-2020');


--En caso de tener que borrar un rol:
CREATE ROLE aux;
REASSIGN OWNED BY analista_negocios_3 TO aux;
DROP OWNED BY analista_negocios_3;
DROP ROLE analista_negocios_3;

CREATE ROLE analista_negocios_3;
GRANT analista_negocios_3 TO analista3;
DROP ROLE aux;

