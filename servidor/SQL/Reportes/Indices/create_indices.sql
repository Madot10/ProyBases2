DROP INDEX index_pilotos_mujeres;
DROP INDEX index_vict_marca;
DROP INDEX index_ganador;

--Indice#1
--Probado Para la BD grupo 7
--EJ: SELECT * FROM persona WHERE femenino is true; 
--Solo para pruebas
CREATE INDEX index_pilotos_mujeres ON persona (femenino) WHERE femenino is TRUE;

--Progbado para la BD le vams 
--EJ: SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';
--Para observar su uso EXPLAIN SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';

CREATE INDEX index_pilotos_mujeres ON pilotos (identificacion) WHERE (pilotos.identificacion).genero = 'f';



--Indice#2
--Probado para la BD le vams
--EJ: explain select * from CARRERAS where puesto_final > 1 or puesto_final <= 3;

CREATE INDEX index_vict_marca ON carreras (puesto_final) WHERE puesto_final > 1 or puesto_final <= 3;

--Indice#3 
--Probado para la BD le vams
--EJ: EXPLAIN SELECT * FROM carreras WHERE puesto_final = 1;

CREATE INDEX index_ganador ON carreras (puesto_final) WHERE puesto_final = 1;


