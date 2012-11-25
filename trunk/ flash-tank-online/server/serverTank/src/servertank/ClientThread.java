package servertank;


import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Observable;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Tri
 */
public class ClientThread extends Observable implements Runnable {

    /** Data input stream*/
    private BufferedReader br;
    // Data output strem
    private PrintWriter pw;
    // Socket connect
    private Socket socket;
    private boolean running;

    public ClientThread(Socket socket) throws IOException {
        this.socket = socket;
        running = false;
        try {
            br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            pw = new PrintWriter(socket.getOutputStream(), true);
            running = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void run() {
        String msg ="";
        
        try {
             pw.println("Welcom server....");
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        try {
            while(running){
                if((msg = br.readLine())!= null){
                    System.out.println("ClientThread Msg from Client: "+msg);
                    msg = msg.toUpperCase();
                    System.out.println("ClientThread msg to client: "+msg);                    
                    pw.println(msg);
                }
                
            }
        } catch (IOException e) {
            running = false;
            e.printStackTrace();
        }
        
        try {
            this.socket.close();
            System.out.println("ClientThread close connect");
        } catch (Exception e) {
        }
        this.setChanged();
        this.notifyObservers(this);
    }
    
    public void stopClient (){
        try{
            this.socket.close();
        }catch (IOException e){
            e.printStackTrace();
        }
    }
}
