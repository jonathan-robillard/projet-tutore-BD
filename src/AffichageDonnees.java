import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import oracle.jdbc.OracleTypes;

public class AffichageDonnees {
	
	final Connection c;
	CallableStatement cs;
	
	public AffichageDonnees() throws SQLException{
		c = DriverManager.getConnection("jdbc:oracle:thin:jrobill/Praline91230@oracle.iut-orsay.fr:1521:etudom");
	}
	
	/**
     * Affiche le nombre de stagiaires pris par chaque entreprise durant les n dernières années.
     * 
     * @param nbAnnees
     * 			Le nombre d'années choisi.  
     * 
     * @throws SQLException  Si jamais il y a un problème avec la base de données.
     */
	public void nbStagiairesPourChaqueEntreprise(int nbAnnees) throws SQLException{
		
		cs = c.prepareCall("{call nbStagiaireParEntreprise(?, ?)}"); // On va utiliser une procedure pl sql stockee
        
        cs.setInt(1, nbAnnees);
        cs.registerOutParameter(2, OracleTypes.CURSOR); // On se prepare a obtenir un curseur contenant plusieurs lignes de données 
        cs.execute();

        ResultSet cursorResultSet = (ResultSet) cs.getObject(2); // On recupere les resultats du curseur dans un result set 
        System.out.println("Le nombre de stagiaires pris par chaque entreprise durant les " + nbAnnees + " dernieres annees :");
        while (cursorResultSet.next ()) // Affichage des resultats
        {
            System.out.println (cursorResultSet.getString(1) + " " + cursorResultSet.getInt(2));
        } 
        cs.close();
    }
	
	/**
     * Affiche le nombre de stages pour toutes les zones géographiques.  
     * 
     * @throws SQLException  Si jamais il y a un problème avec la base de données. 
     */
	public void nbStagiairesPourChaqueZone() throws SQLException{
		
		cs = c.prepareCall("{call nbStagiairePourChaqueZone(?)}");
        cs.registerOutParameter(1, OracleTypes.CURSOR);
        cs.execute();

        ResultSet cursorResultSet = (ResultSet) cs.getObject(1);
        System.out.println("le nombre de stages pour chaque zone geographique :");
        while (cursorResultSet.next ())
        {
            System.out.println (cursorResultSet.getString(1) + " " + cursorResultSet.getString(2) + " " + cursorResultSet.getInt(3));
        } 
        cs.close();
	}
	
	/**
     * Affiche toutes les entreprises et leur contact ayant eu au moins un stage dans les n dernières années.
     * 
     * @param nbAnnees
     * 			Le nombre d'années choisi.   
     * 
     * @throws SQLException  Si jamais il y a un problème avec la base de données.
     */
	public void contactsEntreprises(int nbAnnees) throws SQLException{
		
		cs = c.prepareCall("{call contactsEntreprise(?, ?)}");
        cs.setInt(1, nbAnnees);
        cs.registerOutParameter(2, OracleTypes.CURSOR);
        cs.execute();

        ResultSet cursorResultSet = (ResultSet) cs.getObject(2);
        System.out.println("Les entreprises et tous leurs contacts depuis les " + nbAnnees + " dernieres annees :");
        while (cursorResultSet.next ())
        {
        	System.out.print(cursorResultSet.getString(1));
        	int nbCarac = cursorResultSet.getString(1).length();
        	for(int i = nbCarac; i < 20; i++){ System.out.print(" ");}
        	System.out.print(cursorResultSet.getString(2) + " " + cursorResultSet.getString(3));
        	System.out.println();
            
        } 
        cs.close();
	}
	
	public void affichageStatistiques(int nbAnnees, int annee) throws SQLException{
		
		
		cs = c.prepareCall("{? = CALL nbEtudiantSansStageAnnee(?)}");
        cs.setInt(2, annee);
        cs.registerOutParameter(1, Types.INTEGER);
        cs.execute();
        //System.out.print("le nombre d'étudiants sans stage en " + annee + " : " + cs.getInt(1));
        
        cs.close();
	}

	public static void main(String[] args) throws SQLException{
		
		
		AffichageDonnees affichage = new AffichageDonnees();
		Saisie saisie = new Saisie();
		
		System.out.println("Saisissez un nombre d'annees : ");
		affichage.nbStagiairesPourChaqueEntreprise(saisie.entier());
		System.out.println();
		
		affichage.nbStagiairesPourChaqueZone();
		System.out.println();
		
		System.out.println("Saisissez un nombre d'annees : ");
		affichage.contactsEntreprises(saisie.entier());
		
		//affichage.affichageStatistiques(2, 2015);  ERREURS
		
		
		
		
		
        
    }
}
