/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package netty_server;

import Database.Database;
import Database.testDB;
import Model.UserModel;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.ChannelFactory;
import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

/**
 *
 * @author ThanhTri
 */
public class Netty_Server {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        Database.shareData().ConnectDatabase(
                "jdbc:mysql://localhost:3306/game_db", // link host database
                "root" , ""); // user nama, pass
//        UserModel usertest = Database.shareData().Login("tanloc", "123456");
//        if(usertest !=null) {
//            System.out.println("Login thanh cong ID"+usertest.id);
//        }else {
//            System.out.println("login fail");
//        }
        
         ChannelFactory factory =
            new NioServerSocketChannelFactory(
                    Executors.newCachedThreadPool(),
                    Executors.newCachedThreadPool());

        ServerBootstrap bootstrap = new ServerBootstrap(factory);

        ClientHandler handler = new ClientHandler();
        ChannelPipeline pipeline = bootstrap.getPipeline();
        pipeline.addLast("handler", handler);

        bootstrap.setOption("child.tcpNoDelay", true);
        bootstrap.setOption("child.keepAlive", true);
        try {
            bootstrap.bind(new InetSocketAddress(InetAddress.getByName("127.0.0.1"), 8080));
        } catch (UnknownHostException ex) {
            Logger.getLogger(Netty_Server.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
