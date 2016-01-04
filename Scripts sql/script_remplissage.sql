/* Remplissage de la table Entreprises */
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


/* Remplissage de la table Etudiants */
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


/* Remplissage de la table Statistiques */

INSERT INTO STATISTIQUES
VALUES(nbEtudiantAvecStage(), nbEtudiantSansStage());