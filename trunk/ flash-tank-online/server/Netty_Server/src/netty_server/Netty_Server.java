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
import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.print.attribute.DateTimeSyntax;
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
                "jdbc:mysql://localhost:3306/tank_db", // link host database
                "root" , ""); // user nama, pass
        
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
//        try {
            bootstrap.bind(new InetSocketAddress(5555));
//        } catch (UnknownHostException ex) {
//            Logger.getLogger(Netty_Server.class.getName()).log(Level.SEVERE, null, ex);
//        }
    }
}
