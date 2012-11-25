/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servertank;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Observable;
import java.util.Observer;
import java.util.Vector;

/**
 *
 * @author Tri
 */
public class Server implements Observer {

    private Socket socket;
    private Vector clients;
    private ServerSocket ssocket;
    private int port;
    public boolean listening;
    private ClientThread clientThread;
    private ServerThread serverThread;
    
    public Server (){
        this.clients = new Vector();
        this.port = 2555;
        this.listening = false;
    }
    public void startServer (){
        if(!this.listening){
            this.serverThread = new ServerThread();
            this.serverThread.start();
            this.listening = true;
            
        }
    }
    
    public void stopServer (){
        if(this.listening){
            this.serverThread.stopServerThread();
            
            java.util.Enumeration e = this.clients.elements();
            while(e.hasMoreElements()){
                ClientThread ct = (ClientThread)e.nextElement();
                ct.stopClient();
            }
            this.listening = false;
        }
    }
    
    @Override
    public void update(Observable o, Object arg) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public class ServerThread extends Thread {

        private boolean listen;

        public ServerThread() {
            this.listen = false;
        }

        public void stopServerThread (){
            try {
                Server.this.ssocket.close();
            } catch (IOException e) {
                System.out.println("ServerThread: Stop server");
                e.printStackTrace();
            }
            this.listen = false;
        }
        
        @Override
        public void run() {
            this.listen = true;

            try {
                Server.this.ssocket = new ServerSocket(port);
                while (this.listen) {
                    Server.this.socket = ssocket.accept();
                    System.out.println("ServerThread: Client connect");
                    try {
                        Server.this.clientThread = new ClientThread(socket);
                        Thread t = new Thread(Server.this.clientThread);
                        Server.this.clientThread.addObserver(Server.this);

                        Server.this.clients.addElement(Server.this.clientThread);
                        t.start();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
