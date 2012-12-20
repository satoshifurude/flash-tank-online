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
                handleReady(user, buf);
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
                handleFire(user, buf);
                break;
            case GameDefine.CMD_GET_LIST_ROOM:
                sendListRoom(user);
                break;
            case GameDefine.CMD_LEAVE_ROOM:
                handleLeaveRoom(user, buf);
                break;
            case GameDefine.CMD_CHANGE_SIDE:
                handleChangeSide(user, buf);
            case GameDefine.CMD_FINISH_GAME:
                handleFinishGame(user, buf);
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
        User user = (User)mHashUsers.get(e.getChannel().getId());
        mHashUsers.remove(e.getChannel().getId());
        
        Room room = getRoomWithID(user.mRoom);
        if (room != null) {
            room.removeUser(user);
            if (room.isPlaying()) {
                
            } else {
                if (user == room.getOwner()) {
                    // chuyen key cho nguoi khac
                }

                if (room.getNumPlayer() == 0) {
                    mListRoom.remove(room);
                } else {
                    sendLeaveRoom(room, user);
                }
            }
        }
    }
    
    // mapID
    // num player
    // ID player (stt)
    // 
    // loop
    //
    // player name
    // player position
    private void sendStartGame(Room room) {
        System.out.println("Server : send start game");
        
        room.setPlaying(true);
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_START_GAME_SUCCESS);
        buffer.writeShort(1);
        buffer.writeShort(room.getNumPlayer());
        
        for (int i = 0; i < room.getNumPlayer(); i++) {
            buffer.writeInt(room.getUserByIndex(i).getID());
        }
        
        for (int i = 0; i < room.getNumPlayer(); i++) {
            SendMessage(buffer, room.getUserByIndex(i));
        }
        
//        Enumeration e = mHashUsers.elements();
//        while(e.hasMoreElements()) {
//            User user = (User)e.nextElement();
//            String name = user.getName();
//            buffer.writeInt(user.getID());
//            buffer.writeShort(name.length());
//            buffer.writeBytes(name.getBytes());
//            buffer.writeShort(user.m_iX);
//            buffer.writeShort(user.m_iY);
//        }
//        
//        e = mHashUsers.elements();
//        while(e.hasMoreElements()) {
//            User user = (User)e.nextElement();
//            ChannelBuffer buf = buffer.copy();
//            buf.writeInt(user.getID());
//            SendMessage(buf, user);
//        }
    }
    
     private void handleFinishGame(User user, ChannelBuffer buffer) {
         Room room = getRoomWithID(user.mRoom);
         if (room.isPlaying()) {
             room.setPlaying(false);
         }
         int result = buffer.readShort();
         if (result == 0) { // lose
             Database.shareData().resultBattle(room.idBattle, user.getName(), 0);
         } else if (result == 1) { // win
              Database.shareData().resultBattle(room.idBattle, user.getName(), 1);
         }
     }
    
    private void handleChangeSide(User user, ChannelBuffer buffer) {
        System.out.println("handleChangeSide");
        int side = buffer.readShort();
        user.mSide = side;
        
        ChannelBuffer buf = dynamicBuffer();
        buf.writeShort(GameDefine.CMD_CHANGE_SIDE);
        buf.writeInt(user.getID());
        buf.writeShort(side);
        
        Room room = getRoomWithID(user.mRoom);
        for (int i = 0; i < room.getNumPlayer(); i++) {
            SendMessage(buf, room.getUserByIndex(i));
        }
    }
    
    private void handleLeaveRoom(User user, ChannelBuffer buffer) {
        int roomID = buffer.readShort();
//        System.out.println("room ID = " + roomID);
        int roomNumber = 0;
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID == mListRoom.get(i).getID()) {
                roomNumber = i;
                break;
            }
        }
        
        mListRoom.get(roomNumber).removeUser(user);
        if (user == mListRoom.get(roomNumber).getOwner()) {
            // chuyen key cho nguoi khac
        }
        
        if (mListRoom.get(roomNumber).getNumPlayer() == 0) {
            mListRoom.remove(roomNumber);
        } else {
            sendLeaveRoom(mListRoom.get(roomNumber), user);
        }
    }
    
    private void sendLeaveRoom(Room room, User user) {
//        System.out.println("sendLeaveRoom : id = " + room.getID());
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_LEAVE_ROOM);
        buffer.writeInt(1);
        buffer.writeInt(user.getID());
        int numPlayer = room.getNumPlayer();
        for (int i = 0; i < numPlayer; i++) {
            SendMessage(buffer, room.getUserByIndex(i));
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
            user.setName(username);
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
        user.mSide = GameDefine.SIDE_BLUE;
        
        sendCreateRoomSuccess(user, room);
    }
    
    private void sendCreateRoomSuccess(User user, Room room) {
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_CREATE_ROOM_SUCCESS);
        buffer.writeShort(room.getID());
        buffer.writeShort(user.mSide);
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
            buffer.writeShort(mListRoom.get(i).isPlaying() == true ? 1 : 0);
            buffer.writeShort(mListRoom.get(i).getNumPlayer());
            buffer.writeShort(mListRoom.get(i).getRoomName().length());
            buffer.writeBytes(mListRoom.get(i).getRoomName().getBytes());
            buffer.writeShort(mListRoom.get(i).getOwner().getName().length());
            buffer.writeBytes(mListRoom.get(i).getOwner().getName().getBytes());
        }
        
        SendMessage(buffer, user);
    }
    
    private void handleJoinRoom(User user, ChannelBuffer buffer) {
        int roomID = buffer.readShort();
        int roomNumber = -1;
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID == mListRoom.get(i).getID()) {
                roomNumber = i;
                break;
            }
        }
        
        if (roomNumber == -1) {
            sendListRoom(user);
            return;
        }
        
        user.mSide = getSideInRoom(mListRoom.get(roomNumber));
        user.mRoom = roomID;
        if (mListRoom.get(roomNumber).getNumPlayer() < 4) {
            sendJoinRoomNewbie(user, mListRoom.get(roomNumber));
            mListRoom.get(roomNumber).addUser(user);
            sendJoinRoomSuccess(user, mListRoom.get(roomNumber));
        }
       
    }
    
    private void sendJoinRoomNewbie(User user, Room room) {
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_JOIN_ROOM_SUCCESS);
        buffer.writeShort(GameDefine.CMD_JOIN_ROOM_OLDBIE);
        buffer.writeInt(user.getID());
        buffer.writeShort(user.mSide);
        buffer.writeShort(user.getName().length());
        buffer.writeBytes(user.getName().getBytes());
        
        for (int i = 0; i < room.getNumPlayer(); i++) {
            SendMessage(buffer, room.getUserByIndex(i));
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
            buffer.writeShort(room.getUserByIndex(i).mSide);
            buffer.writeShort(room.getUserByIndex(i).getName().length());
            buffer.writeBytes(room.getUserByIndex(i).getName().getBytes());
        }
 
        SendMessage(buffer, user);
    }
    
    private void handleReady(User user, ChannelBuffer buffer) {
        int isReady = buffer.readShort();
        
        ChannelBuffer buf = dynamicBuffer();
        buf.writeShort(GameDefine.CMD_READY);
        buf.writeInt(user.getID());
        buf.writeShort(isReady);
        
        Room room = getRoomWithID(user.mRoom);
        for (int i = 0; i < room.getNumPlayer(); i++) {
            if (room.getUserByIndex(i) != user) {
                SendMessage(buf, room.getUserByIndex(i));
            }
        }
    }
    
    private void handleStartGame(ChannelBuffer buffer) {
        int roomID = buffer.readShort();
        int idbattles = Database.shareData().CreateBattle();
        
        Room room = getRoomWithID(roomID);
        room.idBattle = idbattles ;
        sendStartGame(room);
    }
    
    private void handleDisconnect(ChannelBuffer buffer) {
        
    }
    
    private void handlePlayerState(User user, ChannelBuffer buffer) {

        Room room = getRoomWithID(user.mRoom);
        user.mDirection = buffer.readShort();
        user.m_isMoving = buffer.readShort();
        user.m_iX = buffer.readInt();
        user.m_iY = buffer.readInt();
        
        sendPlayerState(room);
    }
    
    private void handleFire(User user, ChannelBuffer buffer) {
        System.out.println("fire");
        Room room = getRoomWithID(user.mRoom);
        int numPlayer = room.getNumPlayer();
        for (int i = 0; i < numPlayer; i++) {
            SendMessage(buffer, room.getUserByIndex(i));
        }
    }
    
    private void sendPlayerState(Room room) {
        int numPlayer = room.getNumPlayer();  
        
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_UPDATE_GAME);
        buffer.writeShort(numPlayer);
        
        for (int i = 0; i < numPlayer; i++) {
            buffer.writeInt(room.getUserByIndex(i).getID());
            buffer.writeShort(room.getUserByIndex(i).mDirection);
            buffer.writeShort(room.getUserByIndex(i).m_isMoving);
            buffer.writeInt(room.getUserByIndex(i).m_iX);
            buffer.writeInt(room.getUserByIndex(i).m_iY);
        }
        
        for (int i = 0; i < numPlayer; i++) {
            SendMessage(buffer, room.getUserByIndex(i));
        }
    }
    
    private int generateRoomID() {
        int roomID = 1;
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID < mListRoom.get(i).getID()) {
                return roomID;
            } else {
                roomID = mListRoom.get(i).getID() + 1;
            }
        }
        return roomID;
    }
    
    private Room getRoomWithID(int roomID) {
        int numRoom = mListRoom.size();
        for (int i = 0; i < numRoom; i++) {
            if (roomID == mListRoom.get(i).getID()) {
                return mListRoom.get(i);
            }
        }
        return null;
    }
    
    private int getSideInRoom(Room room) {
        int sideBlue = 0;
        int sideRed = 0;
        
        for (int i = 0; i < room.getNumPlayer(); i++) {
            if (room.getUserByIndex(i).mSide == GameDefine.SIDE_BLUE) {
                sideBlue++;
            } else {
                sideRed++;
            }
        }
        
        if (sideBlue <= sideRed) {
            return GameDefine.SIDE_BLUE;
        } else {
            return GameDefine.SIDE_RED;
        }
    }
}
