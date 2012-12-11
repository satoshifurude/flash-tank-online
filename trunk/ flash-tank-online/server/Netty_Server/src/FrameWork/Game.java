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
    public Hashtable users;
    Thread gameLoop;
    int mFPS;
    private  Game (){
        users = new Hashtable();
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
        Channel channel = (Channel) users.get(id);
        System.out.println("Get channel: "+channel.getId());
        channel.write(buf);
    }

    @Override
    @SuppressWarnings("empty-statement")
    public void messageReceived(MessageEvent e) {
        ChannelBuffer buf = (ChannelBuffer) e.getMessage();
        switch (buf.readShort()) {
            case GameDefine.CMD_LOGIN:
                // Lay IDs cua toan bo user
                Enumeration Ids = users.keys();
                while (Ids.hasMoreElements()) {
                    Integer id = (Integer) Ids.nextElement();
                    SendMessage(buf, id);
                }
                break;
        }
    }

    @Override
    public void channelConnected(ChannelStateEvent e) {
        users.put(e.getChannel().getId(), e.getChannel());
        System.out.println("Game: channel connect");
    }
    
}
