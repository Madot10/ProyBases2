
--TDAs

CREATE TYPE datos_personales AS(
  primer_nombre VARCHAR(30),
  primer_apellido VARCHAR(30),
  genero CHAR(1),
  correo VARCHAR(60)[2],
  segundo_nombre VARCHAR(30),
  segundo_apellido VARCHAR(30)
);

CREATE TYPE metereologia AS(
  temp_pista NUMERIC(3),
  clima CHAR(2)
);

CREATE TYPE motor AS(
  modelo VARCHAR(30),
  cilindros VARCHAR(3),
  cc NUMERIC(4)
);

CREATE TYPE estadistica_general AS(
  velocidad_media NUMERIC(4,2),
  tiempo_mejor_vuelta TIME,
  puesto NUMERIC(3)
);


--Tablas


CREATE TABLE paises(
  id_pais SMALLINT PRIMARY KEY,
  nombre VARCHAR(56) NOT NULL UNIQUE,
  img_bandera BYTEA NOT NULL,
  gentilicio VARCHAR(60) NOT NULL
);


--Revisar FK
CREATE TABLE equipos(
  id_equipo SMALLINT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL,
  id_pais SMALLINT,
  CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON DELETE SET NULL
);


CREATE TABLE vehiculos(
  id_vehiculo SMALLINT PRIMARY KEY,
  modelo VARCHAR(30) NOT NULL,
  categoria CHAR(7) NOT NULL,
  img_vehiculo BYTEA NOT NULL,
  tipo CHAR(2) NOT NULL,
  fabricante_auto VARCHAR(30) NOT NULL,
  fabricante_neumatico VARCHAR(30) NOT NULL,
  modelo_motor motor NOT NULL,
  CONSTRAINT check_categoria CHECK(categoria in ('LMP 900', 'LM GTS', 'LM GT', 'LM P675', 'LM P1', 'LM P2', 'LM GT1', 'LM GT2')),
  CONSTRAINT check_tipo CHECK(tipo in ('h', 'nh'))
);


--Revisar FK
CREATE TABLE personal_tecnicos(
  id_pers_tec SMALLINT PRIMARY KEY,
  identificacion datos_personales NOT NULL,
  cargo CHAR(3)[2] NOT NULL,
  id_equipo SMALLINT,
  id_pais SMALLINT,
  CONSTRAINT fk_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE SET NULL,
  CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON DELETE SET NULL
);


--Revisar FK
CREATE TABLE pilotos(
  id_piloto SMALLINT PRIMARY KEY,
  identificacion datos_personales NOT NULL,
  img_piloto BYTEA NOT NULL,
  fec_nacimiento DATE NOT NULL,
  id_pais SMALLINT,
  fec_fallecimiento DATE,
  CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON DELETE SET NULL
);


CREATE TABLE lotes_repuestos(
  cod_lote SMALLINT,
  id_equipo SMALLINT,
  tipo_pieza CHAR(2) NOT NULL,
  cant_disponible NUMERIC(2) NOT NULL,
  CONSTRAINT fk_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE CASCADE,
  CONSTRAINT pk_lotes_rep PRIMARY KEY(cod_lote,id_equipo)
);


CREATE TABLE pistas(
  id_pista SMALLINT PRIMARY KEY,
  total_km NUMERIC(5) NOT NULL,
  lugares VARCHAR(20)[26] NOT NULL
);


CREATE TABLE eventos(
  id_evento SMALLINT,
  id_pista SMALLINT,
  fecha DATE NOT NULL,
  nota_prensa TEXT[24][10],
  CONSTRAINT fk_pista FOREIGN KEY (id_pista) REFERENCES pistas(id_pista) ON DELETE CASCADE,
  CONSTRAINT pk_eventos PRIMARY KEY(id_evento,id_pista)
);


CREATE TABLE participaciones(
  id_vehiculo SMALLINT,
  id_equipo SMALLINT,
  id_evento SMALLINT,
  id_event_pista SMALLINT,
  nro_equipo NUMERIC(3) NOT NULL,
  entrevista TEXT[3][5],
  CONSTRAINT fk_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE CASCADE,
  CONSTRAINT fk_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE CASCADE,
  CONSTRAINT pk_participaciones PRIMARY KEY(id_vehiculo,id_equipo,id_evento,id_event_pista)
);


CREATE TABLE plantillas(
  id_piloto SMALLINT,
  id_parti_vehiculo SMALLINT,
  id_parti_equipo SMALLINT,
  id_parti_evento SMALLINT,
  id_parti_evento_pista SMALLINT,
  CONSTRAINT fk_piloto FOREIGN KEY (id_piloto) REFERENCES pilotos(id_piloto) ON DELETE CASCADE,
  CONSTRAINT fk_participaciones FOREIGN KEY (id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista) REFERENCES participaciones(id_vehiculo, id_equipo, id_evento, id_event_pista) ON DELETE CASCADE,
  CONSTRAINT pk_plantillas PRIMARY KEY(id_piloto,id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista)
);


CREATE TABLE ensayos(
  id_ensayo SMALLINT,
  id_parti_vehiculo SMALLINT,
  id_parti_equipo SMALLINT,
  id_parti_evento SMALLINT,
  id_parti_evento_pista SMALLINT,
  estadistica estadistica_general NOT NULL,
  CONSTRAINT fk_participaciones FOREIGN KEY (id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista) REFERENCES participaciones(id_vehiculo,
  id_equipo, id_evento, id_event_pista) ON DELETE CASCADE,
  CONSTRAINT pk_ensayo PRIMARY KEY(id_ensayo,id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista)
);


CREATE TABLE carreras(
  id_carrera SMALLINT,
  id_parti_vehiculo SMALLINT,
  id_parti_equipo SMALLINT,
  id_parti_evento SMALLINT,
  id_parti_evento_pista SMALLINT,
  estado CHAR(2) NOT NULL,
  puesto_final NUMERIC(2),
  CONSTRAINT check_estado CHECK(estado in ('a','c','d','np')),
  CONSTRAINT fk_participaciones FOREIGN KEY (id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista) REFERENCES participaciones(id_vehiculo,
  id_equipo, id_evento, id_event_pista) ON DELETE CASCADE,
  CONSTRAINT pk_carrera PRIMARY KEY(id_carrera,id_parti_vehiculo,id_parti_equipo,id_parti_evento,id_parti_evento_pista)
);


CREATE TABLE sucesos(
  id_suceso SMALLINT,
  id_evento SMALLINT,
  id_event_pista SMALLINT,
  hora NUMERIC(2) NOT NULL,
  metereologia metereologia,
  CONSTRAINT fk_evento FOREIGN KEY (id_evento,id_event_pista) REFERENCES eventos(id_evento,id_pista) ON DELETE CASCADE,
  CONSTRAINT pk_sucesos PRIMARY KEY(id_suceso, id_evento, id_event_pista)
);


CREATE TABLE resumen_datos(
  id_resumen SMALLINT,
  id_suceso SMALLINT,
  id_suceso_evento SMALLINT,
  id_suceso_pista SMALLINT,
  id_carrera SMALLINT,
  id_car_vehiculo SMALLINT,
  id_car_equipo SMALLINT,
  id_car_evento SMALLINT,
  id_car_pista SMALLINT,
  nro_vueltas NUMERIC(3) NOT NULL,
  estadistica estadistica_general NOT NULL,
  tipo_estrategia CHAR(1),
  temp_cockpit NUMERIC(3),
  CONSTRAINT check_estrategia CHECK(tipo_estrategia in ('a','i','c')),
  CONSTRAINT fk_suceso FOREIGN KEY (id_suceso,id_suceso_evento,id_suceso_pista) REFERENCES sucesos(id_suceso,id_evento,id_event_pista) ON DELETE CASCADE,
  CONSTRAINT fk_carrera FOREIGN KEY (id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista) REFERENCES carreras(id_carrera, id_parti_vehiculo,id_parti_equipo, id_parti_evento, id_parti_evento_pista) ON DELETE CASCADE,
  CONSTRAINT pk_resumen_datos PRIMARY KEY(id_resumen,id_suceso,id_suceso_evento,id_suceso_pista,id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista)
);


CREATE TABLE fallas(
  id_falla SMALLINT,
  id_suceso SMALLINT,
  id_suceso_evento SMALLINT,
  id_suceso_pista SMALLINT,
  id_carrera SMALLINT,
  id_car_vehiculo SMALLINT,
  id_car_equipo SMALLINT,
  id_car_evento SMALLINT,
  id_car_pista SMALLINT,
  pieza CHAR(2) NOT NULL,
  tipo_falla CHAR(1) NOT NULL,
  CONSTRAINT check_tipo_falla CHECK(tipo_falla in ('p','t')),
  CONSTRAINT fk_suceso FOREIGN KEY (id_suceso,id_suceso_evento,id_suceso_pista) REFERENCES sucesos(id_suceso,id_evento,id_event_pista) ON DELETE CASCADE,
  CONSTRAINT fk_carrera FOREIGN KEY (id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista) REFERENCES carreras(id_carrera, id_parti_vehiculo,id_parti_equipo, id_parti_evento, id_parti_evento_pista) ON DELETE CASCADE,
  CONSTRAINT pk_falla PRIMARY KEY(id_falla,id_suceso,id_suceso_evento,id_suceso_pista,id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista)
);


CREATE TABLE parada_pits(
  id_parada SMALLINT,
  --ids de la carrera
  id_carrera SMALLINT,
  id_car_vehiculo SMALLINT,
  id_car_equipo SMALLINT,
  id_car_evento SMALLINT,
  id_car_pista SMALLINT,
  --ids del suceso
  id_suceso SMALLINT,
  id_suc_evento SMALLINT,
  id_suc_pista SMALLINT,
  --id de la falla
  id_falla SMALLINT,
  id_falla_suceso SMALLINT,
  id_falla_s_evento SMALLINT,
  id_falla_s_pista SMALLINT,
  id_falla_carrera SMALLINT,
  id_falla_vehiculo SMALLINT,
  id_falla_equipo SMALLINT,
  id_falla_evento SMALLINT,
  id_falla_pista SMALLINT,
  --id del piloto
  id_piloto SMALLINT,

  --Motivo de la parada
  motivo CHAR(2) NOT NULL,

  --Constraints
  CONSTRAINT fk_carrera FOREIGN KEY (id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista) REFERENCES carreras(id_carrera, id_parti_vehiculo,id_parti_equipo, id_parti_evento, id_parti_evento_pista) ON DELETE CASCADE,

  CONSTRAINT fk_suceso FOREIGN KEY (id_suceso,id_suc_evento,id_suc_pista) REFERENCES sucesos(id_suceso,id_evento,id_event_pista) ON DELETE CASCADE,

  CONSTRAINT fk_falla FOREIGN KEY (id_falla, id_falla_suceso, id_falla_s_evento,
  id_falla_s_pista, id_falla_carrera, id_falla_vehiculo, id_falla_equipo,
  id_falla_evento, id_falla_pista) REFERENCES fallas(id_falla, id_suceso,  id_suceso_evento, id_suceso_pista, id_carrera, id_car_vehiculo, id_car_equipo,
  id_car_evento, id_car_pista) ON DELETE SET NULL,

  CONSTRAINT fk_piloto FOREIGN KEY (id_piloto) REFERENCES pilotos(id_piloto) ON DELETE SET NULL,

  CONSTRAINT pk_parada_pits PRIMARY KEY(id_parada,id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista,id_suceso,id_suc_evento,id_suc_pista)
);


CREATE TABLE accidentes(
  id_accid SMALLINT,
  --id de la falla
  id_falla SMALLINT,
  id_falla_suceso SMALLINT,
  id_falla_evento SMALLINT,
  id_falla_pista SMALLINT,
  id_falla_carrera SMALLINT,
  id_falla_vehiculo SMALLINT,
  id_falla_equipo SMALLINT,
  id_falla_car_evento SMALLINT,
  id_falla_car_pista SMALLINT,
  --ids de la carrera
  id_carrera SMALLINT,
  id_car_vehiculo SMALLINT,
  id_car_equipo SMALLINT,
  id_car_evento SMALLINT,
  id_car_pista SMALLINT,
  --ids del suceso
  id_suceso SMALLINT,
  id_suc_evento SMALLINT,
  id_suc_pista SMALLINT,

  --Motivo de la parada
  tipo CHAR(1) NOT NULL,

  --Constraints
  CONSTRAINT check_tipo CHECK(tipo in ('i','c')),

  CONSTRAINT fk_carrera FOREIGN KEY (id_carrera,id_car_vehiculo,id_car_equipo,id_car_evento,id_car_pista) REFERENCES carreras(id_carrera, id_parti_vehiculo,id_parti_equipo, id_parti_evento, id_parti_evento_pista) ON DELETE CASCADE,

  CONSTRAINT fk_suceso FOREIGN KEY (id_suceso,id_suc_evento,id_suc_pista) REFERENCES sucesos(id_suceso,id_evento,id_event_pista) ON DELETE CASCADE,

  CONSTRAINT fk_falla FOREIGN KEY (id_falla, id_falla_suceso, id_falla_evento,
  id_falla_pista, id_falla_carrera, id_falla_vehiculo, id_falla_equipo,
  id_car_evento, id_car_pista) REFERENCES fallas(id_falla, id_suceso,  id_suceso_evento, id_suceso_pista, id_carrera, id_car_vehiculo, id_car_equipo,
  id_car_evento, id_car_pista) ON DELETE SET NULL,
  
  CONSTRAINT pk_accidentes PRIMARY KEY(id_accid, id_falla, id_falla_suceso,
  id_falla_evento, id_falla_pista, id_falla_carrera, id_falla_vehiculo,  id_falla_equipo, id_falla_car_evento, id_falla_car_pista, id_carrera,id_car_vehiculo, id_car_equipo, id_car_evento, id_car_pista, id_suceso, id_suc_evento, id_suc_pista)
);
