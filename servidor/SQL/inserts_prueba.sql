
--Probando el select de un type (TDA)

SELECT (modelo_motor).cc FROM vehiculos WHERE id_vehiculo = 1;

--Inserts de prueba

--Para crear un ensayo, primero hay que crear un nuevo evento
insert into eventos(id_pista, fecha) VALUES (1,'18-09-2020');

INSERT INTO pistas(total_km,lugares) VALUES(555,ARRAY['lugar 1','lugar 2', 'lugar 3']);


INSERT INTO paises(nombre, img_bandera, gentilicio) VALUES('Zimbabue','asdasdasd','zimbabuense');
INSERT INTO equipos(nombre, id_pais) VALUES('Los campeones',1);
INSERT INTO equipos(nombre, id_pais) VALUES('les champions',1);
INSERT INTO vehiculos(modelo, categoria, img_vehiculo, tipo, fabricante_auto, fabricante_neumatico, modelo_motor) VALUES('Ferrari LG500','LMP 900','asdasdasd','nh','Ferrari','Michelin',ROW('modelo 1','LPG',350));
INSERT INTO vehiculos(modelo, categoria, img_vehiculo, tipo, fabricante_auto, fabricante_neumatico, modelo_motor) VALUES('Chevrolet MPX','LMP 900','asdasdasd','nh','Chevrolet','Michelin',ROW('modelo','LPG',350));

INSERT INTO participaciones(nro_equipo, id_vehiculo, id_equipo, id_evento, id_event_pista) VALUES(77,1,1,1,1);
INSERT INTO participaciones(nro_equipo, id_vehiculo, id_equipo, id_evento, id_event_pista) VALUES(37,2,2,1,1);
--piloto
INSERT INTO pilotos(identificacion, img_piloto, fec_nacimiento, id_pais) VALUES(ROW('Alan','Sosa','m',ARRAY['correo@gmail.com'],'Alan','Sosa'),'asdasdasd','18/12/1980',1);
INSERT INTO pilotos(identificacion, img_piloto, fec_nacimiento, id_pais) VALUES(ROW('Miguel','De Olim','m',ARRAY['correo@gmail.com'],'Miguel','De Olim'),'asdasdasd','24/06/1972',1);
INSERT INTO pilotos(identificacion, img_piloto, fec_nacimiento, id_pais) VALUES(ROW('Miguel','De Olim','m',ARRAY['correo@gmail.com'],null,null),'asdasdasd','24/06/1972',1);
--plantillas
INSERT INTO plantillas(id_piloto, parti_nro_equipo, id_parti_vehiculo, id_parti_equipo, id_parti_evento, id_parti_evento_pista) VALUES(1,77,1,1,1,1);
INSERT INTO plantillas(id_piloto, parti_nro_equipo, id_parti_vehiculo, id_parti_equipo, id_parti_evento, id_parti_evento_pista) VALUES(1,37,2,2,1,1);
