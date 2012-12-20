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
            this.host       = host;
            this.username   = username;
            this.pass       = pass;

            this.conn       = DriverManager.getConnection(this.host, this.username, this.pass);
            this.statement  = conn.createStatement();
        } catch (Exception ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
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
//        Statement statement;
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
                
                dateTime    = getDate();
                queryLogin  = "INSERT INTO `logins`(`id_user`, `time`)"
                        + " VALUES (" + userModel.id + ",'" + dateTime + "')";
                
                executeUpdate(queryLogin);
                System.out.println("Database: Login success username : '"+user+"' Pass: '"+pass+"'");
                return userModel;
            } else {
                System.out.println("Database: Login fail username : '"+user+"' Pass: '"+pass+"'");
                return null;
            }
        } catch (Exception ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void Logout(int id) {
        String queryLogout;
        String dateTime;       
        dateTime = getDate();        
        queryLogout = "INSERT INTO `logouts`(`userID`, `time`) VALUES ("+id
                +",'"+dateTime+"')";
        executeUpdate(queryLogout);        
    }

    // Khi start game thi se dc luu vao DB
    public int CreateBattle () {
        
          String gameName="tank";  
          int id= 0;
          String sqlCreate = "INSERT INTO `battles`(`game`, `time`) VALUES ('"+gameName+"','"+getDate()+"')";
          String sqlIdBattle = "SELECT MAX(id) as maxID FROM `battles`";
          
          executeUpdate(sqlCreate);
          ResultSet resultSet = executeQuery(sqlIdBattle);
        try {
            if(resultSet.next()){
                id = resultSet.getInt("maxID");
                System.out.println("Database: create game success ID "+id);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
          return id;
    }
    public void resultBattle (int idBattle,String name,int result){
        String query = "select * from users where "
            + "name ='" + name + "'";
        ResultSet resultSet = executeQuery(query);
        try {
            if(resultSet.next()){
                int id = resultSet.getInt("id");
                String sql = "INSERT INTO `battles_detail`"
                    + " (`idbattle`, `iduser`, `result`)"
                    + " VALUES ("+idBattle+","+id+" , "+result+")";
                executeUpdate(sql);
                String sqlUser = "update users"
                    + " set win = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+id
                    + "     and battles_detail.result = 1),"
                    + "     lose = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+id
                    + "     and battles_detail.result = 0) "
                    + "     where id = "+id;                 
                   executeUpdate(sqlUser);
                   System.out.println("resultBattle success ID :"+idBattle+"   userID:"+id+" KQ: "+result);
            }else {
                System.out.println("resultBattle Fail: ko tim thay user");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public void resultBattle (int id,int[] winner,int[] loser){
        String sqlWin;
        String sqlLose;
        String sqlUser;
        for(int i=0;i < winner.length;i++){
            sqlWin = "INSERT INTO `battles_detail`"
                    + " (`idbattle`, `iduser`, `result`)"
                    + " VALUES ("+id+","+winner[i]+" , 1)";
            executeUpdate(sqlWin);
            
            sqlUser = "update users"
                    + " set win = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+winner[i]
                    + "     and battles_detail.result = 1),"
                    + "     lose = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+winner[i]
                    + "     and battles_detail.result = 0) "
                    + "     where id = "+winner[i]; 
            
            executeUpdate(sqlUser);
        }
        
        for(int i=0;i < loser.length;i++){
            sqlLose = "INSERT INTO `battles_detail`"
                    + " (`idbattle`, `iduser`, `result`)"
                    + " VALUES ("+id+","+loser[i]+" , 0)";
            executeUpdate(sqlLose);
            
            sqlUser = "update users"
                    + " set win = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+loser[i]
                    + "     and battles_detail.result = 1),"
                    + "     lose = (select count(*) from battles_detail"
                    + "     where battles_detail.iduser = "+loser[i]
                    + "     and battles_detail.result = 0) "
                    + "     where id = "+loser[i]; 
            
            executeUpdate(sqlUser);
        }
    }
    private String getDate (){
        Date d = new Date(System.currentTimeMillis());
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return df.format(d);
    }
    private ResultSet executeQuery(String query){
        try {
             return statement.executeQuery(query);
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }        
        return  null;
    }
    private void  executeUpdate(String query){
        try {
            statement.executeUpdate(query);
        } catch (SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
