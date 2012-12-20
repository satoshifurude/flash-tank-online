/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import com.sun.jmx.remote.security.MBeanServerAccessController;
import java.util.LinkedList;
import java.util.List;
import org.jboss.netty.buffer.ChannelBuffer;
import static org.jboss.netty.buffer.ChannelBuffers.*;

/**
 *
 * @author Loc
 */
public class Room {
    private int mID;
    private String mName;
    private String mPassword;
    private User mOwner;
    private List<User> mListUser;
    
    public Room(int id, User user, String name, String password) {
        mID = id;
        mName = name;
        mOwner = user;
        mOwner.mRoom = mID;
        mPassword = password;
        mListUser = new LinkedList<User>();
        mListUser.add(user);
    }
    
    public void addUser(User user) {
        if (mListUser.size() < GameDefine.MAX_PLAYER_IN_ROOM) {
            mListUser.add(user);
        }
    }
    
    public void removeUser(User user) {
        mListUser.remove(user);
    }
    
    public User getUser(int id) {
        for (int i = 0, size = mListUser.size(); i < size; i++) {
            if (mListUser.get(i).getID() == id) {
                return mListUser.get(i);
            }
        }
        
        return null;
    }
    
    public User getUserByIndex(int index) {
        return mListUser.get(index);
    }
    
    public User getOwner() {
        return mOwner;
    }
    
    public int getNumPlayer() {
        return mListUser.size();
    }
    
    public String getRoomName() {
        return mName;                
    }
    
    public String getPassword() {
        return mPassword;                
    }
    
    public int getID() {
        return mID;
    }
    
    private void sendStartGame() {
        System.out.println("Server : send start game");
        
        int numPlayer = mListUser.size();                
        
        ChannelBuffer buffer = dynamicBuffer();
        buffer.writeShort(GameDefine.CMD_START_GAME_SUCCESS);
        buffer.writeShort(1); // map id
        buffer.writeShort(numPlayer);
        
        for (int i = 0; i < numPlayer; i++) {
            String name = mListUser.get(i).getName();
            buffer.writeInt(mListUser.get(i).getID());
            buffer.writeShort(name.length());
            buffer.writeBytes(name.getBytes());
            buffer.writeShort(mListUser.get(i).m_iX);
            buffer.writeShort(mListUser.get(i).m_iY);
        }
        
        for (int i = 0; i < numPlayer; i++) {
            ChannelBuffer buf = buffer.copy();
            buf.writeInt(mListUser.get(i).getID());
//            SendMessage(mListUser.get(i), user);
        }
    }
}
