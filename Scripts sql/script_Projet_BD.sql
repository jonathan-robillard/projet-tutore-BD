/* Suppression des tables et types */
DROP TABLE Entreprises;
DROP TABLE Etudiants;
DROP TYPE Etudiant_Ty;
DROP TYPE StageEtudiant_Ty;
DROP TYPE Entreprise_Ty;
DROP TABLE STATISTIQUES;


/* Creation type Entreprise, d'une table et remplissage de la table */
CREATE OR REPLACE TYPE Entreprise_Ty AS OBJECT(
NumEntreprise VARCHAR2(5),
NomEntreprise VARCHAR2(30),
Ville VARCHAR2(30),
Departement VARCHAR2(30)
);
/

CREATE TABLE Entreprises OF Entreprise_Ty(NumEntreprise PRIMARY KEY);
/

INSERT INTO Entreprises
VALUES(1,'BNP Paribas', 'Paris', 'Paris');

INSERT INTO Entreprises
VALUES(2,'RATP', 'Palaiseau', 'Essonne');

INSERT INTO Entreprises
VALUES(4,'Appartoo', 'Paris', 'Paris');

INSERT INTO Entreprises
VALUES(5,'Improveus', 'Paris', 'Paris');

INSERT INTO Entreprises
VALUES(6,'iKNSA', 'Cergy', 'Val-d Oise');

INSERT INTO Entreprises
VALUES(7,'La Meduse', 'Paris', 'Paris');

INSERT INTO Entreprises
VALUES(8,'Route des Hommes', 'Paris', 'Paris');

INSERT INTO Entreprises
VALUES(9,'Netysoft', 'Bievres', 'Essonne');

/* Creation du type StageEtudiant */

CREATE OR REPLACE TYPE StageEtudiant_Ty AS OBJECT(
NumStage VARCHAR2(5),
DateTrouvee DATE,
Sujet VARCHAR2(50),
Entreprise REF Entreprise_Ty
);
/

/* Creation du type Etudiant, d'une table et remplissage */

CREATE OR REPLACE TYPE Etudiant_Ty AS OBJECT(
NumEtudiant VARCHAR2(5),
NomEtudiant VARCHAR2(20),
PrenomEtudiant VARCHAR2(20),
Stage StageEtudiant_Ty
);
/

CREATE TABLE Etudiants OF Etudiant_Ty(NumEtudiant PRIMARY KEY);
/

INSERT INTO Etudiants
SELECT '1', 'ZAPATO', 'Michel', StageEtudiant_Ty('1', TO_DATE('15/09/2015','DD/MM/YY'), 'Programmation Web', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'BNP Paribas';

INSERT INTO Etudiants
SELECT '2', 'DAGOBERT', 'Didier', StageEtudiant_Ty('2', TO_DATE('09/01/2016','DD/MM/YY'), 'Reseau', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'RATP';

INSERT INTO Etudiants
SELECT '3', 'BOMBUT', 'Tristan', StageEtudiant_Ty( '3', TO_DATE('27/12/2015','DD/MM/YY'), 'Programmation Web', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'Appartoo';

INSERT INTO Etudiants
SELECT '4', 'HIERNE', 'Jerome', StageEtudiant_Ty( '4', TO_DATE('11/12/2015','DD/MM/YY'), 'Programmation Web', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'Appartoo';

INSERT INTO Etudiants
SELECT '5', 'BOMBUT', 'Tristan', StageEtudiant_Ty( '5', TO_DATE('06/10/2015','DD/MM/YY'), 'Reseau', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'Improveus';

INSERT INTO Etudiants
SELECT '6', 'PAQUITO', 'Ernesto', StageEtudiant_Ty( '2', TO_DATE('23/01/2016','DD/MM/YY'), 'Reseau', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'RATP';

INSERT INTO Etudiants
SELECT '7', 'TRILARD', 'Thibaud', StageEtudiant_Ty( '6', TO_DATE('29/01/2016','DD/MM/YY'), 'DÈveloppement Java', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'iKNSA';

INSERT INTO Etudiants
SELECT '8', 'FERASSE', 'LÈonard', StageEtudiant_Ty( '7', TO_DATE('01/01/2016','DD/MM/YY'), 'DÈveloppement iOS', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'La Meduse';

INSERT INTO Etudiants
SELECT '9', 'BALET', 'Robert', StageEtudiant_Ty( '8', TO_DATE('03/02/2016','DD/MM/YY'), 'Base de Donnees', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'Route des Hommes';

INSERT INTO Etudiants
SELECT '10', 'VALEMONTRE', 'Arthur', StageEtudiant_Ty( '9', TO_DATE('12/01/2016','DD/MM/YY'), 'DÈveloppement iOS', REF(e))
FROM Entreprises e
WHERE e.NomEntreprise = 'Netysoft';

INSERT INTO Etudiants
VALUES ('11', 'HENRY', 'Thierry', NULL); -- On insert des etudiants sans stage

INSERT INTO Etudiants
VALUES ('12', 'BOND', 'James', NULL);

INSERT INTO Etudiants
VALUES ('13', 'POGBA', 'Paul', NULL);

INSERT INTO Etudiants
VALUES ('14', 'AURIER', 'Serge', NULL);

/*########################################################*/
/* récupérer le nombre d'étudiants avec stage cette année */

CREATE OR REPLACE FUNCTION nbEtudiantAvecStage
RETURN number IS
total number := 0;
BEGIN
SELECT COUNT(*) INTO total
FROM Etudiants e
WHERE extract(year from e.STAGE.DateTrouvee) = extract(year from sysdate); -- on regarde si l'annee de la date du stage est egale a celle de la date actuelle

RETURN total;
END;
/

/* récupérer le nombre d'étudiants sans stage cette année */

CREATE OR REPLACE FUNCTION nbEtudiantSansStage
RETURN number IS
total number := 0;
BEGIN
SELECT COUNT(*) into total
FROM Etudiants e
WHERE extract(year from e.STAGE.DateTrouvee) <> extract(year from sysdate) OR e.Stage IS NULL;

RETURN total;
END;
/

/* récupérer le nombre d'étudiants sans stage à une certaine date pour une année précédente choisie par l'utilisateur */

CREATE OR REPLACE FUNCTION nbEtudiantSansStageAnnee(annee NUMBER)
RETURN number IS
total number := 0;
BEGIN
SELECT COUNT(*) into total
FROM Etudiants e
WHERE extract(year from e.STAGE.DateTrouvee) <> annee OR e.Stage IS NULL;

RETURN total;
END;
/

/* le nombre de stagiaires pris par chaque entreprise durant les n dernières années */

CREATE OR REPLACE PROCEDURE nbStagiaireParEntreprise(nbAnnees IN NUMBER, results OUT sys_refcursor)
AS
BEGIN
open results for
SELECT et.nomEntreprise as nom, COUNT(numEtudiant) as nbEtudiants
FROM Etudiants e, Entreprises et
WHERE e.STAGE.Entreprise.numEntreprise = et.numEntreprise
AND e.Stage.dateTrouvee > sysdate - (365 * nbAnnees)
GROUP BY et.nomEntreprise;
END;
/


/* le nombre moyen de stagiaires encadrés par les entreprises dans les n dernières années */

CREATE OR REPLACE FUNCTION nbMoyenEtudiantsDansEntreprise(nbAnnees IN NUMBER)
RETURN NUMBER IS
moyenne NUMBER(5) := 0;
cpt NUMBER(5) := 0;
CURSOR monCurseur IS
SELECT COUNT(numEtudiant) as nbEtudiants
FROM Etudiants e, Entreprises et
WHERE e.STAGE.Entreprise.numEntreprise = et.numEntreprise
AND e.Stage.dateTrouvee > sysdate - (365 * nbAnnees)
GROUP BY et.nomEntreprise;
BEGIN
for Cur IN monCurseur LOOP
cpt := cpt + 1;
moyenne := moyenne + Cur.nbEtudiants;
END LOOP;
moyenne := moyenne / cpt;
return moyenne;
END;
/

/* le nombre de stages par zone géographique choisi par l'utilisateur (département, ville) */

CREATE OR REPLACE FUNCTION nbStagesParZone(villeStage IN VARCHAR2, departementStage IN VARCHAR2)
RETURN number IS
total number := 0;
BEGIN
SELECT COUNT(*) into total
FROM Etudiants et, Entreprises e
WHERE et.Stage.Entreprise.numEntreprise = e.numEntreprise
AND e.ville = villeStage
AND e.Departement = departementStage;

RETURN total;
END;
/

/* le nombre de stages pour toutes les zones géographiques (département, ville) */

CREATE OR REPLACE PROCEDURE nbStagiairePourChaqueZone(results OUT sys_refcursor)AS
BEGIN
open results for
SELECT e.ville, e.departement, COUNT(numEtudiant) as nbEtudiants
FROM Etudiants et, Entreprises e
WHERE et.Stage.Entreprise.numEntreprise = e.numEntreprise
GROUP BY e.ville, e.departement;
END;
/

/* récupérer toutes les entreprises et leur contact ayant eu au moins un stage dans les n dernières années */

CREATE OR REPLACE PROCEDURE contactsEntreprise(nbAnnees IN NUMBER, results OUT sys_refcursor)
AS
BEGIN
open results for
SELECT en.nomEntreprise, et.nomEtudiant, et.prenomEtudiant
FROM Entreprises en, Etudiants et
WHERE en.numEntreprise = et.Stage.entreprise.numEntreprise
AND et.Stage.dateTrouvee > sysdate - (365 * nbAnnees)
GROUP BY en.nomEntreprise, et.nomEtudiant, et.prenomEtudiant
ORDER BY en.nomEntreprise;
END;
/

CREATE TABLE STATISTIQUES(nbEtudiantsAvecStage NUMBER, nbEtudiantsSansStage NUMBER);

INSERT INTO STATISTIQUES
VALUES(nbEtudiantAvecStage(), nbEtudiantSansStage());

CREATE OR REPLACE TRIGGER TRG_ent
AFTER INSERT OR UPDATE ON Entreprises
FOR EACH ROW
BEGIN
UPDATE STATISTIQUES
SET nbEtudiantsAvecStage = nbEtudiantAvecStage(),
nbEtudiantsSansStage = nbEtudiantSansStage();
dbms_output.put_line('Valeurs de la table STATISTIQUES mises a jour.');
END;
/

CREATE OR REPLACE TRIGGER TRG_etu
AFTER INSERT OR UPDATE ON Etudiants
FOR EACH ROW
BEGIN
UPDATE STATISTIQUES
SET nbEtudiantsAvecStage = nbEtudiantAvecStage(),
nbEtudiantsSansStage = nbEtudiantSansStage();
dbms_output.put_line('Valeurs de la table STATISTIQUES mises a jour.');
END;
/





