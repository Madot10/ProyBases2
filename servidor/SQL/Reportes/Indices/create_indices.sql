DROP INDEX index_pilotos_mujeres;
DROP INDEX index_vict_marca;
DROP INDEX index_vict_ensayo;


--Indice#1
--Probado EN SISTEMA_LE_VAMS (dim_piloto)

CREATE INDEX index_pilotos_mujeres ON dim_piloto (genero) WHERE genero = 'femenino';

/*EXPLAIN SELECT DISTINCT
                p.id_piloto,
                --Año de primera participacion
               (SELECT MIN(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto =  pilot.id_piloto) AnnoPrimeraParticipacion,
               --Numero total de participaciones
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto) CantParticipaciones,
                --Veces en el 1er puesto
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND parti.puesto_final_carrera = 1) CantPrimerLugar,
               --Veces en el podium (1,2 y3er lugar)
                (SELECT COUNT(t.anno) FROM ft_participacion parti INNER JOIN dim_piloto pilot on parti.id_dim_piloto = pilot.id_piloto INNER JOIN dim_tiempo t on parti.id_dim_tiempo = t.id_tiempo WHERE p.id_piloto = pilot.id_piloto AND( parti.puesto_final_carrera = 1 OR parti.puesto_final_carrera = 2 OR parti.puesto_final_carrera = 3)) CantPodium,
                --Datos
                p.nombre || ' ' || p.apellido NombrePiloto, p.fec_nacimiento, p.fec_fallecimiento,  EXTRACT(YEAR FROM age(p.fec_nacimiento)), p.img_piloto, p.gentilicio, p.img_bandera BanderaPiloto
        FROM ft_participacion parti
            INNER JOIN dim_piloto p on parti.id_dim_piloto = p.id_piloto and p.genero = 'femenino';
*/

--Indice#2
--Probado EN SISTEMA_LE_VAMS (ft_participacion)

CREATE INDEX index_vict_carrera ON ft_participacion (puesto_final_carrera) 
	WHERE puesto_final_carrera = 1 OR puesto_final_carrera = 2 OR puesto_final_carrera = 3;
	
CREATE INDEX index_vict_ensayo ON ft_participacion (puesto_final_ensayo)
	WHERE puesto_final_ensayo = 1 OR puesto_final_ensayo = 2 OR puesto_final_ensayo = 3;


/****************************************************************************************************/  

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


