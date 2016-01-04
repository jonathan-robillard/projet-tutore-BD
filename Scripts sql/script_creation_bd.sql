DROP TABLE Entreprises;
DROP TABLE Etudiants;
DROP TYPE Etudiant_Ty;
DROP TYPE StageEtudiant_Ty;
DROP TYPE Entreprise_Ty;
DROP TABLE STATISTIQUES;


/* Creation type Entreprise et d'une table */
CREATE OR REPLACE TYPE Entreprise_Ty AS OBJECT(
NumEntreprise VARCHAR2(5),
NomEntreprise VARCHAR2(30),
Ville VARCHAR2(30),
Departement VARCHAR2(30)
);
/

CREATE TABLE Entreprises OF Entreprise_Ty(NumEntreprise PRIMARY KEY);
/

/* Creation du type StageEtudiant */
CREATE OR REPLACE TYPE StageEtudiant_Ty AS OBJECT(
NumStage VARCHAR2(5),
DateTrouvee DATE,
Sujet VARCHAR2(50),
Entreprise REF Entreprise_Ty
);
/

/* Creation du type Etudiant, d'une table */

CREATE OR REPLACE TYPE Etudiant_Ty AS OBJECT(
NumEtudiant VARCHAR2(5),
NomEtudiant VARCHAR2(20),
PrenomEtudiant VARCHAR2(20),
Stage StageEtudiant_Ty
);
/

CREATE TABLE Etudiants OF Etudiant_Ty(NumEtudiant PRIMARY KEY);
/

/* Creation de la table statistiques */
CREATE TABLE STATISTIQUES(nbEtudiantsAvecStage NUMBER, nbEtudiantsSansStage NUMBER);