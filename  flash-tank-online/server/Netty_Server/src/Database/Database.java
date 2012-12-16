/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;

import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import FrameWork.User;
import Model.UserModel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

/**
 *
 * @author ThanhTri
 */
public class Database {

    private static Database instance;

    public static Database shareData() {
        if (instance == null) {
            instance = new Database();
        }
        return instance;
    }
    Connection conn = null;
    public String host;
    public String db;
    public String username;
    public String pass;
    Statement statement;

    public void ConnectDatabase(String host, String username, String pass) {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
//            conn = DriverManager.getConnection(
//                    "jdbc:mysql://localhost:3306/cakephp", 
//                    "root","");
            this.host = host;
            this.username = username;
            this.pass = pass;

            this.conn = DriverManager.getConnection(this.host, this.username, this.pass);
            this.statement = conn.createStatement();
        } catch (Exception ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private ResultSet executeQuery(String query) {
        try {
            statement = conn.createStatement();
            return statement.executeQuery(query);
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    private void executeUpdate(String query) {
        try {
            statement = conn.createStatement();
            statement.execute(query);
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private String getDateTime() {
        Date d = new Date(System.currentTimeMillis());
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return  df.format(d);
    }

    public UserModel Login(String user, String pass) {
        // Ghi log login
        String queryLogin;
        String queryLogining;
        // Check login
        String query = "select * from users where "
                + "name ='" + user + "'"
                + " and pass = '" + pass + "'"
                + " and iLogin = false";
        String dateTime; // current time 
        ResultSet resultSet;
        UserModel userModel;

        try {
            resultSet = executeQuery(query);
            if (resultSet.next()) {
                userModel = new UserModel();                
                userModel.id = resultSet.getInt("id");
                userModel.name = resultSet.getString("name");
                userModel.policy = resultSet.getInt("policy");
                userModel.win = resultSet.getInt("win");
                userModel.lose = resultSet.getInt("lose");
                userModel.iLogin = resultSet.getBoolean("ilogin");    
                
                dateTime = getDateTime();
                queryLogin = "INSERT INTO `logins`(`id_user`, `login`)"
                        + " VALUES (" + userModel.id + ",'" + dateTime + "')";
                statement.execute(queryLogin);
                return userModel;
            } else {
                return null;
            }

        } catch (Exception ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public boolean Logout(int id) {
        String queryLogout;
        String dateTime;

        dateTime    = getDateTime();
        queryLogout = "INSERT INTO `logouts`(`userID`, `time`) VALUES ("+id+
                ",'"+ dateTime+"')";
        executeUpdate(queryLogout);
        return true;
    }

    public void addBattles(User[] winners, User[] losers) {
    }
}
