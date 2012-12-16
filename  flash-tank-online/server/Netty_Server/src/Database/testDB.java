/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;
import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.*;
/**
 *
 * @author ThanhTri
 */
public class testDB {
    Connection conn = null;
    Properties connectProps = new Properties();
    public void connectBD () throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        connectProps.put("user", "root");
        connectProps.put("password", "");
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cakephp", "root","");
            
            Statement stmt = conn.createStatement();
//            String query = "insert into books (`isbn`,`title`,`des`) values ('JDBC','Server','To Java server')";
            String query = "select * from books";
            ResultSet result = stmt.executeQuery(query);
            
            while(result.next()){
                int id = result.getInt("id");
                String isbn = result.getString("isbn");
                String title = result.getString("title");
                String des = result.getString("des");
                
                System.out.println("Book  ID:"+id+"-- ISBN:"+isbn+" -- title:"+title+" --des:"+des);
                
            }
//            stmt.execute(query);
            
            
        } catch (SQLException ex) {
            Logger.getLogger(testDB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
