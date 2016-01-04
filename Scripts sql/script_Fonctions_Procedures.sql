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

/* Creation des triggers */

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
