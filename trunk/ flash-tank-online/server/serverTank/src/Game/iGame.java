/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package game;
import Game.ClientThread;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;


/**
 *
 * @author ThanhTri
 */
public abstract class iGame {
//    Hashtable<String, Session> user;
    public static float deltaTime = 0;
    public static int fps = 0;
    
    public abstract void setFPS (int fps);
    public abstract int getFPS ();    
    public abstract void onUpdate ();  
    public abstract void addClient(ClientThread client);
    public abstract void sendMessage (ClientThread toUser,ByteBuffer msg);
    public abstract void receiverMessage (ClientThread formUser,ByteBuffer msg);
    public class GameLoop extends Thread {
        long lastTime;
        int CountFPS=0;
        float countTime=0; 
        public GameLoop (){
            lastTime = System.currentTimeMillis();
        }
        @Override
        public void run() {
           long FPSTime = (long)(1000.0f/(float)iGame.this.getFPS());       
           while(true){              
               long curTime = System.currentTimeMillis();
               long deltaTime = curTime - lastTime;     
               lastTime = curTime;               
               CountFPS++;
               countTime+=deltaTime;
               
               iGame.deltaTime = deltaTime;                
               iGame.this.onUpdate();               
               if(countTime >=1000){
                   iGame.fps = CountFPS;
                   countTime = 0;
                   CountFPS = 0;
               }
               
               long updateTime = System.currentTimeMillis()-curTime;
               long sleepTime = (FPSTime - updateTime);
               
               if(sleepTime>0 ){
                    try {
                        this.sleep(sleepTime);
                    } catch (InterruptedException ex) {
                    }
               }
           }           
        }        
    }
    
}
