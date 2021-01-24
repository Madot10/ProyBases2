DROP INDEX index_pilotos_mujeres;
DROP INDEX index_vict_marca;

--Indice #1 Reporte #16 - Pilotos mujeres 
--Probado Para la BD grupo 7
--EJ: SELECT * FROM persona WHERE femenino is true; 
--Solo para pruebas
CREATE INDEX index_pilotos_mujeres ON persona (femenino) WHERE femenino is TRUE;

--Progbado para la BD le vams 
--EJ: SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';
--Para observar su uso EXPLAIN SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';

CREATE INDEX index_pilotos_mujeres ON pilotos (identificacion) WHERE (pilotos.identificacion).genero = 'f';



--Indice  Reporte #15 - Victorias por Marca
--Probado para la BD le vams
--EJ: explain select * from CARRERAS where puesto_final > 1 or puesto_final <= 3;

CREATE INDEX index_vict_marca ON carreras (puesto_final) WHERE puesto_final > 1 or puesto_final <= 3;




