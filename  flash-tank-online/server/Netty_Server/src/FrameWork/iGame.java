/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.MessageEvent;


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
    
    public abstract void messageReceived(MessageEvent e);
    public abstract void channelConnected(ChannelStateEvent e);
    
    public abstract void Multicast(ChannelBuffer b);
    public abstract void OnUpdate ();  
    public abstract void SendMessage(ChannelBuffer b,String user);
    
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
               iGame.this.OnUpdate();               
               
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
