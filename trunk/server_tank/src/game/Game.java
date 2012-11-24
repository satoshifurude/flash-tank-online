/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package game;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Hashtable;
import network.Session;

/**
 *
 * @author ThanhTri
 */
public abstract class Game {
//    Hashtable<String, Session> user;
    static float deltaTime = 0;
    
    public abstract void setFPS (int fps);
    public abstract int getFPS ();
    
    public abstract void Multicast(ByteBuffer b);
    public abstract void SendMsgTo (Session s,ByteBuffer b);
    public abstract void Update ();    
    
    public class GameLoop extends Thread {
        float lastTime;
        public GameLoop (){
            
        }
        @Override
        public void run() {
           
        }        
    }
    
}
