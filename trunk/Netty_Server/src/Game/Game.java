/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import java.util.Hashtable;
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
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void SendMessage(ChannelBuffer b,String user) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void messageReceived(MessageEvent e) {
        e.getChannel().getId();
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void channelConnected(ChannelStateEvent e) {
        users.put(e.getChannel().getId(), e.getChannel());
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
