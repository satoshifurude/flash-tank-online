/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jboss.netty.buffer.ChannelBuffer;


/**
 *
 * @author ThanhTri
 */
public abstract class iGame {
//    Hashtable<String, Session> user;
    static float deltaTime = 0;
    static int fps = 0;
    
    public abstract void setFPS (int fps);
    public abstract int getFPS ();
    
    public abstract void Multicast(ByteBuffer b);
    public abstract void Update ();  
    public abstract void SendMessage(ByteBuffer b);
    public abstract void ReceiveMessage(ChannelBuffer b,String user);
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
               iGame.this.Update();               
               
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
