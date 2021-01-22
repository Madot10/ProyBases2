
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


--Revocar todos los accesos por defecto
--revocamos comportamiento por defecto
--ALTER default privileges revoke execute on functions from public;
REVOKE ALL PRIVILEGES ON DATABASE le_vams_dw FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

--Revocar todos los accesos por defecto a las funciones
REVOKE EXECUTE ON FUNCTION reporte_rank_nro_equipo(NUMERIC,NUMERIC) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_logros_piloto(SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_datos_participacion(SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_participaciones_marcas_modelos(VARCHAR(30),VARCHAR(30)) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_piloto_joven(SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_piloto_mayor(smallint) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_pilotos_mayor_participaciones() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_ganador_primera_participacion(SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_top_vel_media(CHAR(3),SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_distancias_mas_largas(NUMERIC(3)) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_pilotos_podiums() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_pilotos_nunca_meta() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_victoria_por_marca(BOOLEAN) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_mujeres_pilotos(SMALLINT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION reporte_datos_participacion_mujeres(SMALLINT) FROM PUBLIC;


--definir roles
--rol analista 1
--select * from dim_tiempo;
GRANT SELECT ON TABLE dim_equipo TO analista_negocios_1;
GRANT SELECT ON TABLE dim_piloto TO analista_negocios_1;
GRANT SELECT ON TABLE dim_tiempo TO analista_negocios_1;
GRANT SELECT ON TABLE dim_vehiculo TO analista_negocios_1;
GRANT SELECT ON TABLE ft_participacion TO analista_negocios_1;

--rol analista 2
--Al analista 2 se le da el rol de analista_negocios_1 para que pueda acceder a las tablas
--que son requeridas por las funciones
GRANT analista_negocios_1 to analista2;
--Reporte 4
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
--Al analista 3 se le da el rol de analista_negocios_1 para que pueda acceder a las tablas
--que son requeridas por las funciones
GRANT analista_negocios_1 to analista3;
--Reporte 11
GRANT EXECUTE ON FUNCTION reporte_top_vel_media(CHAR(3),SMALLINT) TO analista_negocios_3;
--Reporte 12
GRANT EXECUTE ON FUNCTION reporte_distancias_mas_largas(NUMERIC(3)) TO analista_negocios_3;
--Reporte 13
GRANT EXECUTE ON FUNCTION reporte_pilotos_podiums() TO analista_negocios_3;
--Reporte 14
GRANT EXECUTE ON FUNCTION reporte_pilotos_nunca_meta() TO analista_negocios_3;
--Reporte 15
GRANT EXECUTE ON FUNCTION reporte_victoria_por_marca(BOOLEAN) TO analista_negocios_3;
--Reporte 16.1
GRANT EXECUTE ON FUNCTION reporte_mujeres_pilotos(SMALLINT) TO analista_negocios_3;
--Reporte 16.2
GRANT EXECUTE ON FUNCTION reporte_datos_participacion_mujeres(SMALLINT) TO analista_negocios_3;

--rol desarrollador
GRANT analista_negocios_1 to dev;
GRANT analista_negocios_2 to dev;
GRANT analista_negocios_3 to dev;
--Permiso de inserts

--PROBAR

GRANT INSERT ON TABLE dim_equipo TO desarrollador;
GRANT INSERT ON TABLE dim_piloto TO desarrollador;
GRANT INSERT ON TABLE dim_tiempo TO desarrollador;
GRANT INSERT ON TABLE dim_vehiculo TO desarrollador;
GRANT INSERT ON TABLE ft_participacion TO desarrollador;



--Pruebas
--select * from dim_tiempo;
--Reporte 4
--SELECT * FROM reporte_rank_nro_equipo(1::SMALLINT, 2000);
--Reporte 15
--SELECT * FROM reporte_victoria_por_marca(FALSE);
--insert into dim_equipo(nombre, nombre_pais, img_bandera) VALUES ('Nuevo equipo2', 'Nuevo país2', 'Nueva imagen2');


--En caso de tener que borrar un rol:
CREATE ROLE aux;
REASSIGN OWNED BY analista_negocios_2 TO aux;
DROP OWNED BY analista_negocios_2;
DROP ROLE analista_negocios_2;

drop user analista2;
CREATE USER analista2 LOGIN PASSWORD '12345';
CREATE ROLE analista_negocios_2;
GRANT analista_negocios_2 TO analista2;
DROP ROLE aux;
