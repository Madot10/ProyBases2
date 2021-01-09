-- CREATE database le_vams_dw;


--DIM TIEMPO
DROP SEQUENCE IF EXISTS sec_tiempo;
CREATE SEQUENCE sec_tiempo
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE dim_tiempo(
  id_tiempo SMALLINT DEFAULT nextval('sec_tiempo'),
  anno NUMERIC(4) NOT NULL,
  mes NUMERIC(2) NOT NULL,
  dia numeric(2) NOT NULL,
	dia_semana NUMERIC(1) NOT NULL,
  CONSTRAINT pk_dim_tiempo PRIMARY KEY (id_tiempo)
);

--DIM VEHÍCULO
DROP SEQUENCE IF EXISTS sec_veh;
CREATE SEQUENCE sec_veh
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;
    
CREATE TABLE dim_vehiculo (
	id_vehiculo SMALLINT DEFAULT nextval('sec_veh') PRIMARY KEY,
	categoria CHAR(7) NOT NULL,
    modelo_motor VARCHAR (30) NOT NULL,
  img_vehiculo TEXT NOT NULL,
  tipo CHAR(2) NOT NULL,
  modelo VARCHAR(30) NOT NULL,
  cilindros VARCHAR(3) NOT NULL,
  cc NUMERIC(4) NOT NULL,
  --Agregar categorias de otra decada
  CONSTRAINT check_categoria CHECK(categoria in ('C1', 'C2', 'C3', 'S1', 'S2' , 'GTP', 'LM GT875', 'WSC', 'IMSAGTS', 'LM P', 'LMP 900', 'LM GTP', 'LM GTS', 'LM GT', 'LM P675', 'LM P1', 'LM P2', 'LM GT1', 'LM GT2')),
  CONSTRAINT check_tipo CHECK(tipo in ('h', 'nh'))
);
  
  
--DIM MARCA
DROP SEQUENCE IF EXISTS sec_marca;
CREATE SEQUENCE sec_marca
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE dim_marca(
	id_marca SMALLINT DEFAULT nextval('sec_marca') PRIMARY KEY,
  tipo CHAR(2) NOT NULL,
  fabricante VARCHAR(30) NOT NULL,
  CONSTRAINT check_tipo CHECK(tipo in ('au', 'ne'))
);
  

--DIM EQUIPO
DROP SEQUENCE IF EXISTS sec_equipos;
CREATE SEQUENCE sec_equipos
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;
 
CREATE TABLE dim_equipo(
	id_equipo SMALLINT DEFAULT nextval('sec_equipos') PRIMARY KEY,
    nombre VARCHAR(35) NOT NULL,
    nombre_pais VARCHAR(60) NOT NULL,
    img_piloto TEXT NOT NULL,
	img_bandera TEXT NOT NULL
);
  
--DIM PILOTO
DROP SEQUENCE IF EXISTS sec_pilotos;
CREATE SEQUENCE sec_pilotos
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;
 
CREATE TABLE dim_piloto (
	id_piloto SMALLINT DEFAULT nextval('sec_pilotos') PRIMARY KEY,
  fec_nacimiento DATE NOT NULL,
  fec_fallecimiento DATE,
  gentilicio VARCHAR(60) NOT NULL,
  img_bandera TEXT NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  apellido VARCHAR(30) NOT NULL,
  genero CHAR(10) NOT NULL,
  CONSTRAINT check_gen CHECK(genero in ('femenino', 'masculino'))
);
  
--FACT TABLE PARTICIPACION
  CREATE TABLE ft_participacion(
  	nro_equipo NUMERIC(3) NOT NULL,
    puesto_final_carrera NUMERIC(2) NOT NULL,
    puesto_final_ensayo NUMERIC(2) NOT NULL,
    total_km_pista NUMERIC(5,3) NOT NULL, --degeneradas
    velocidad_media_carrera  NUMERIC(5,2) NOT NULL,
    velocidad_media_ensayo  NUMERIC(5,2) NOT NULL,
    tiempo_mejor_vuelta_carrera TIME NOT NULL,
    tiempo_mejor_vuelta_ensayo TIME NOT NULL,
    nro_vueltas_carrera_total NUMERIC(3) NOT NULL,
    estado CHAR(2) NOT NULL,
    --fk
    id_dim_tiempo SMALLINT,
    id_dim_vehiculo SMALLINT,
    id_dim_marca SMALLINT,
    id_dim_equipo SMALLINT,
    id_dim_piloto SMALLINT,
    CONSTRAINT fk_dim_tiempo FOREIGN KEY (id_dim_tiempo) REFERENCES dim_tiempo(id_tiempo) ON DELETE CASCADE,
    CONSTRAINT fk_dim_vehiculo FOREIGN KEY (id_dim_vehiculo) REFERENCES dim_vehiculo(id_vehiculo) ON DELETE CASCADE,
    CONSTRAINT fk_dim_marca FOREIGN KEY (id_dim_marca) REFERENCES dim_marca(id_marca) ON DELETE CASCADE,
    CONSTRAINT fk_dim_equipo FOREIGN KEY (id_dim_equipo) REFERENCES dim_equipo(id_equipo) ON DELETE CASCADE,
    CONSTRAINT fk_dim_piloto FOREIGN KEY (id_dim_piloto) REFERENCES dim_piloto(id_piloto) ON DELETE CASCADE
  );
