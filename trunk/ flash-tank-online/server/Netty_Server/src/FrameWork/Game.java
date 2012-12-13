/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.MessageEvent;
import static org.jboss.netty.buffer.ChannelBuffers.*;


/**
 *
 * @author ThanhTri
 */
public class Game extends iGame{
    public static Game instance;
    public static Game shareGame () {
        if(instance == null){
            instance = new Game();
        }
        return instance;
    }
    // Chua channel (session) cua nguoi choi key la ID cua channel do
    public Hashtable mHashUsers;
    Thread gameLoop;
    int mFPS;
    private  Game (){
        mHashUsers = new Hashtable();
        mFPS = 10;
        gameLoop = new GameLoop();
        gameLoop.start();
        
    }
    @Override
    public void setFPS(int fps) {
        this.mFPS = fps;
    }

    @Override
    public int getFPS() {
        return mFPS;
    }  
    
    @Override
    public void Multicast(ChannelBuffer b) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void OnUpdate() {
//        System.out.println("Update:"+Game.deltaTime);
    }

    @Override
    public void SendMessage(ChannelBuffer buf,Integer id) {
//        Channel channel = (Channel) mHashUsers.get(id);
//        if(channel.isConnected()){
//            channel.write(buf);
//            System.out.println("Send message successful (ID:"+id+")");
//        }else{
//            System.out.println("Send message fail: client disconnect");
//            System.out.println("Remove user (ID:"+id+")");
//            mHashUsers.remove(id);
//        }
    }

    @Override
    @SuppressWarnings("empty-statement")
    public void messageReceived(MessageEvent e) {
        
//        ChannelBuffer buf = (ChannelBuffer) e.getMessage();
//        int testInt = buf.readInt();
//        System.out.println("receive message " + testInt);
//        Enumeration Ids = mHashUsers.keys();
//        while (Ids.hasMoreElements()) {
//            Integer id = (Integer) Ids.nextElement();
//            SendMessage(buf, id);
//        } 
    }
    
    
    
    @Override
    public void channelConnected(ChannelStateEvent e) {
        User user = new User(e.getChannel());
        mHashUsers.put(user.getID(), user);
        System.out.println("Game: channel connect");
    }
    // xac dinh 
    public void channelClosed(ChannelStateEvent e){
        System.out.println("Game: channel close remove ID");
        mHashUsers.remove(e.getChannel().getId());
    }
    
}
