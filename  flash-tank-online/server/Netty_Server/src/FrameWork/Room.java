/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

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
    private List<User> mListUser;
    
    public Room(int id) {
        mID = id;
        mListUser = new LinkedList<User>();                
    }
    
    public void addUser(User user) {
        if (mListUser.size() < GameDefine.MAX_PLAYER_IN_ROOM) {
            mListUser.add(user);
        }
    }
    
    public User getUser(int id) {
        for (int i = 0, size = mListUser.size(); i < size; i++) {
            if (mListUser.get(i).getID() == id) {
                return mListUser.get(i);
            }
        }
        
        return null;
    }
    
    public int getNumPlayer() {
        return mListUser.size();
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
