/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package netty_server;

import Database.testDB;
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
        
        testDB t = new testDB();
        try {
            t.connectBD();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Netty_Server.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Netty_Server.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Netty_Server.class.getName()).log(Level.SEVERE, null, ex);
        }
        
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
