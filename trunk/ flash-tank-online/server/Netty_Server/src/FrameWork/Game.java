/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import Database.Database;
import Model.UserModel;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
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
    public List<Room> mListRoom;
    Thread gameLoop;
    int mFPS;
    private  Game (){
        mHashUsers = new Hashtable();
        mListRoom = new LinkedList<Room>();
        mFPS = 10;
//        gameLoop = new GameLoop();
//        gameLoop.start();
        
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
        sendPlayerState();
                
    }

    @Override
    public void SendMessage(ChannelBuffer buf, User user) {
        Channel channel = user.getChannel();
        if(channel.isConnected()){
            channel.write(buf);
//            System.out.println("Send message successful (ID: " + user.getID() + ")");
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
//        System.out.println("--- Message receive --- cmd = " + cmd);
        switch(cmd) {
            case GameDefine.CMD_LOGIN:
                handleLogin(user, buf);
                break;
            case GameDefine.CMD_CREATE_ROOM:
                handleCreateRoom(user, buf);
                break;
            case GameDefine.CMD_JOIN_ROOM:
                handleJoinRoom(user, buf);
                break;
            case GameDefine.CMD_READY:
                handleReady(buf);
                break;
            case GameDefine.CMD_START_GAME:
                handleStartGame(buf);
                break;
            case GameDefine.CMD_UPDATE_GAME:
                handlePlayerState(user, buf);
                break;
            case GameDefine.CMD_DISCONNECT:
                handleDisconnect(buf);
                break;
            case GameDefine.CMD_FIRE:
                handleFire(buf);
                break;
            case GameDefine.CMD_GET_LIST_ROOM:
                sendListRoom(user);
                break;
            case GameDefine.CMD_LEAVE_ROOM:
                handleLeaveRoom(user, buf);
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
//        if (mHashUsers.size() == 0) {
//            gameLoop.stop();
//            gameLoop = null;
//        }
    }
    
    // mapID
    // num player
    // ID player (stt)
    // 
    // loop
    //
    // player name
    // player position
    private void sendStartGame() {
        System.out.println("Server : send start game");
        
        int numPlayer = mHashUsers.size();                
        
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_START_GAME_SUCCESS);
        buffer.writeShort(1);
        buffer.writeShort(numPlayer);
        
        Enumeration e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            String name = user.getName();
            buffer.writeInt(user.getID());
            buffer.writeShort(name.length());
            buffer.writeBytes(name.getBytes());
            buffer.writeShort(user.m_iX);
            buffer.writeShort(user.m_iY);
        }
        
        e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            ChannelBuffer buf = buffer.copy();
            buf.writeInt(user.getID());
            SendMessage(buf, user);
        }
    }
    
    private void handleLeaveRoom(User user, ChannelBuffer buffer) {
        int roomID = buffer.readShort();
        int roomNumber = 0;
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID == mListRoom.get(i).getID()) {
                roomNumber = i;
                break;
            }
        }
        
        if (mListRoom.get(roomNumber).getNumPlayer() == 1) {
            mListRoom.remove(roomNumber);
        }
    }
    
    private void handleLogin(User user, ChannelBuffer buffer) {
        short lengthUserName = buffer.readShort();
        byte[] byteUserName = new byte[lengthUserName];
        buffer.readBytes(byteUserName, 0, lengthUserName);
        
        short lengthPassword = buffer.readShort();
        byte[] bytePassword = new byte[lengthPassword];
        buffer.readBytes(bytePassword, 0, lengthPassword);
        
        String username = new String(byteUserName);
        String password = new String(bytePassword);
        
        UserModel userDB = Database.shareData().Login(username, password);
        if (userDB == null) {
            ChannelBuffer buf = dynamicBuffer();
            buf.writeShort(GameDefine.CMD_LOGIN_FAIL);
            SendMessage(buf, user);                    
        } else {
            user.setName(userDB.name);
            ChannelBuffer buf = dynamicBuffer();
            buf.writeShort(GameDefine.CMD_LOGIN_SUCCESS);
            buf.writeInt(user.getID());
            buf.writeShort(user.getName().length());
            buf.writeBytes(user.getName().getBytes());
            SendMessage(buf, user); 
        }
    }
    
    private void handleCreateRoom(User user, ChannelBuffer buffer) {
        short lengthRoomName = buffer.readShort();
        byte[] byteRoomName = new byte[lengthRoomName];
        buffer.readBytes(byteRoomName, 0, lengthRoomName);
        
        short lengthPassword = buffer.readShort();
        byte[] bytePassword = new byte[lengthPassword];
        buffer.readBytes(bytePassword, 0, lengthPassword);
        
        String roomName = new String(byteRoomName);
        String password = new String(bytePassword);
        
        Room room = new Room(generateRoomID(), user, roomName, password);
        mListRoom.add(room);
        
        sendCreateRoomSuccess(user, room);
    }
    
    private void sendCreateRoomSuccess(User user, Room room) {
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_CREATE_ROOM_SUCCESS);
        buffer.writeShort(room.getID());
        buffer.writeShort(room.getRoomName().length());
        buffer.writeBytes(room.getRoomName().getBytes());
        buffer.writeShort(room.getPassword().length());
        buffer.writeBytes(room.getPassword().getBytes());
        
        SendMessage(buffer, user);    
    }
    
    private void sendListRoom(User user) {
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_GET_LIST_ROOM);
        
        int numRoom = mListRoom.size();
        
        buffer.writeShort(numRoom);
        for (int i = 0; i < numRoom; i++) {
            buffer.writeInt(mListRoom.get(i).getID());
            buffer.writeShort(mListRoom.get(i).getRoomName().length());
            buffer.writeBytes(mListRoom.get(i).getRoomName().getBytes());
            buffer.writeShort(mListRoom.get(i).getOwner().getName().length());
            buffer.writeBytes(mListRoom.get(i).getOwner().getName().getBytes());
        }
        
        SendMessage(buffer, user);
    }
    
    private void handleJoinRoom(User user, ChannelBuffer buffer) {
        int roomID = buffer.readShort();
        int roomNumber = 0;
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID == mListRoom.get(i).getID()) {
                roomNumber = i;
                break;
            }
        }
        
        if (mListRoom.get(roomNumber).getNumPlayer() < 4) {
            mListRoom.get(roomNumber).addUser(user);
            sendJoinRoomSuccess(user, mListRoom.get(roomNumber));
        }
    }
    
    private void sendJoinRoomSuccess(User user, Room room) {
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_JOIN_ROOM_SUCCESS);
        buffer.writeShort(GameDefine.CMD_JOIN_ROOM_NEWBIE);
        buffer.writeShort(room.getID());
        buffer.writeInt(room.getOwner().getID());
        buffer.writeShort(room.getRoomName().length());
        buffer.writeBytes(room.getRoomName().getBytes());
        buffer.writeShort(room.getNumPlayer());
        
        for (int i = 0; i < room.getNumPlayer(); i++) {
            buffer.writeInt(room.getUserByIndex(i).getID());
            buffer.writeShort(room.getUserByIndex(i).getName().length());
            buffer.writeBytes(room.getUserByIndex(i).getName().getBytes());
        }
 
        SendMessage(buffer, user);
    }
    
    private void handleReady(ChannelBuffer buffer) {
        
    }
    
    private void handleStartGame(ChannelBuffer buffer) {
        sendStartGame();
    }
    
    private void handleDisconnect(ChannelBuffer buffer) {
        
    }
    
    private void handlePlayerState(User user, ChannelBuffer buffer) {
//        if (gameLoop == null) {
//            gameLoop = new GameLoop();
//            gameLoop.start();
//        }
        buffer.readShort();
        user.mDirection = buffer.readShort();
        user.m_isMoving = buffer.readShort();
        user.m_iX = buffer.readInt();
        user.m_iY = buffer.readInt();
        
        sendPlayerState();
    }
    
    private void handleFire(ChannelBuffer buffer) {
        System.out.println("fire");
        Enumeration e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            SendMessage(buffer, user);
        }
    }
    
    private void sendPlayerState() {
        int numPlayer = mHashUsers.size();  
        
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_UPDATE_GAME);
        buffer.writeShort(numPlayer);
        
        Enumeration e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            buffer.writeInt(user.getID());
            buffer.writeShort(user.mDirection);
            buffer.writeShort(user.m_isMoving);
            buffer.writeInt(user.m_iX);
            buffer.writeInt(user.m_iY);
        }
        
        e = mHashUsers.elements();
        while(e.hasMoreElements()) {
            User user = (User)e.nextElement();
            SendMessage(buffer, user);
        }
    }
    
    private int generateRoomID() {
        return 0;
    }
}
