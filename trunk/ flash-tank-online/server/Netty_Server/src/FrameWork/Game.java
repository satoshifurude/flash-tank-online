/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
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
    public void SendMessage(ChannelBuffer buf, User user) {
        Channel channel = user.getChannel();
        if(channel.isConnected()){
            channel.write(buf);
            System.out.println("Send message successful (ID: " + user.getID() + ")");
        }else{
            System.out.println("Send message fail: client disconnect");
            System.out.println("Remove user (ID: " + user.getID() + ")");
            mHashUsers.remove(user.getID());
        }
    }

    @Override
    @SuppressWarnings("empty-statement")
    public void messageReceived(MessageEvent e) {
        User user = (User)mHashUsers.get(e.getChannel().getId());
        ChannelBuffer buf = (ChannelBuffer) e.getMessage();
        
        short cmd = buf.readShort();
        System.out.println("--- Message receive --- cmd = " + cmd);
        switch(cmd) {
            case GameDefine.CMD_LOGIN:
                handleLogin(user, buf);
                break;
            case GameDefine.CMD_CREATE_ROOM:
                handleCreateRoom(buf);
                break;
            case GameDefine.CMD_JOIN_ROOM:
                handleJoinRoom(buf);
                break;
            case GameDefine.CMD_READY:
                handleReady(buf);
                break;
            case GameDefine.CMD_START_GAME:
                handleStartGame(buf);
                break;
            case GameDefine.CMD_INPUT:
                handleInput(buf);
                break;
            case GameDefine.CMD_DISCONNECT:
                handleDisconnect(buf);
                break;
        }
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
    
    private void sendStartGame() {
        // mapID
        // num player
        // ID player (stt)
        // 
        // loop
        //
        // player name
        // player position
        
        System.out.println("Server : send start game");
        
        int numPlayer = mHashUsers.size();                
        
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_START_GAME_SUCCESS);
        buffer.writeShort(1);
        buffer.writeShort(numPlayer);
        buffer.writeShort(10);
        
        Enumeration e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            String name = user.getName();
            buffer.writeShort(name.length());
            buffer.writeBytes(name.getBytes());
            buffer.writeShort(1);
            buffer.writeShort(2);
        }
        
        e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            SendMessage(buffer, user);
        }
    }
    
    private void handleLogin(User user, ChannelBuffer buffer) {
        short length = buffer.readShort();
        byte[] byteName = new byte[length];
        buffer.readBytes(byteName, 0, length);
        String name = new String(byteName);
        
        user.setName(name);
        System.out.println("username = " + user.getName());
        sendStartGame();
    }
    
    private void handleCreateRoom(ChannelBuffer buffer) {
        
    }
    
    private void handleJoinRoom(ChannelBuffer buffer) {
        
    }
    
    private void handleReady(ChannelBuffer buffer) {
        
    }
    
    private void handleStartGame(ChannelBuffer buffer) {
        
    }
    
    private void handleDisconnect(ChannelBuffer buffer) {
        
    }
    
    private void handleInput(ChannelBuffer buffer) {
        
    }
}
