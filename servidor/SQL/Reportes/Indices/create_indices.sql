--Indice para consultar a las pilotoss mujeres 
--Probado Para la BD grupo 7
--EJ: SELECT * FROM persona WHERE femenino is true; 
CREATE INDEX index_pilotos_mujeres ON persona (femenino) WHERE femenino is TRUE;

--Progbado para la BD le vams 
--EJ: SELECT * FROM pilotos WHERE (pilotos.identificacion).genero= 'f';

CREATE INDEX index_pilotos_mujeres ON pilotos (identificacion) WHERE (pilotos.identificacion).genero = 'f';
