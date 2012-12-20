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
    public int idBattle;
    private String mName;
    private String mPassword;
    private User mOwner;
    private List<User> mListUser;
    private boolean mIsPlaying;
    
    public Room(int id, User user, String name, String password) {
        mIsPlaying = false;
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
    
    public void setPlaying(boolean bool) {
        mIsPlaying = bool;
    }
    
    public boolean isPlaying() {
        return mIsPlaying;
    }
}
