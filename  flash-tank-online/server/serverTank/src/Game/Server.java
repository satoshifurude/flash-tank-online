/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import game.iGame;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ThanhTri
 */
public class Server {

    public static int PORT = 555;
    public ServerSocketChannel ssc;
    public boolean listening = false;
    public Vector clients;
    public ServerThread serverThread;
    public iGame game;
    public Server() {
        clients = new Vector();        
    }
    public void setGame (iGame game){
        this.game = game;
    }
    public void starServer() {
        if (listening == false) {
            try {
                listening = true;                
                ssc = ServerSocketChannel.open();
                ssc.socket().bind(new InetSocketAddress(
                        InetAddress.getLocalHost(), PORT));
                serverThread = new ServerThread(ssc);
                serverThread.start();
                System.out.println("Server start success ");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    public void stopServer() {
         if(this.listening){
            this.serverThread.stopThread();
            
            java.util.Enumeration e = this.clients.elements();
            while(e.hasMoreElements()){
                ClientThread ct = (ClientThread)e.nextElement();
                ct.StopClient();
            }
            this.listening = false;
            System.out.println("Server stop success ");
        }
    }

    public class ServerThread extends Thread {

        public ServerSocketChannel ssc;
        public boolean iListen = false;

        public ServerThread(ServerSocketChannel ssc) {
            this.ssc = ssc;
            iListen = true;
        }

        public void stopThread() {
            if (Server.this.listening) {
                try {
                    ssc.close();
                } catch (IOException ex) {
                    Logger.getLogger(Server.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        @Override
        public void run() {
            while (iListen) {
                try {
                    SocketChannel chanel = ssc.accept();
                    ClientThread client = new ClientThread(chanel);
                    client.start();
                    Server.this.clients.add(client);
                    
                    System.out.println("Server accept new client success");

                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}
