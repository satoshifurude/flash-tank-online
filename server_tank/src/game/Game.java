/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package game;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;
import network.Session;

/**
 *
 * @author ThanhTri
 */
public abstract class Game {
//    Hashtable<String, Session> user;
    static float deltaTime = 0;
    static int fps = 0;
    
    public abstract void setFPS (int fps);
    public abstract int getFPS ();
    
    public abstract void Multicast(ByteBuffer b);
    public abstract void SendMsgTo (Session s,ByteBuffer b);
    public abstract void Update ();    
    
    public class GameLoop extends Thread {
        long lastTime;
        int CountFPS=0;
        float countTime=0;
        public GameLoop (){
            lastTime = System.currentTimeMillis();
        }
        @Override
        public void run() {
           long FPSTime = (long)(1000.0f/(float)Game.this.getFPS());       
           while(true){              
               long curTime = System.currentTimeMillis();
               long deltaTime = curTime - lastTime;     
               lastTime = curTime;               
               CountFPS++;
               countTime+=deltaTime;
               
               Game.deltaTime = deltaTime;                
               Game.this.Update();               
               
               if(countTime >=1000){
                   Game.fps = CountFPS;
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
