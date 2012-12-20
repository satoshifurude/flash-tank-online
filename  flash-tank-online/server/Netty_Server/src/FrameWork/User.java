/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

import org.jboss.netty.channel.Channel;
import java.lang.Integer;
        
/**
 *
 * @author Loc
 */
public class User {
    private Channel mChannel;
    private String  mName;
    public int mDirection;
    public int m_iX;
    public int m_iY;
    public int m_isMoving;
    public int mRoom;
    public int mSide;
    
    public User(Channel channel) {
        mChannel = channel;                
        m_iX = 500;
        m_iY = 500;
    }
    
    public void setName(String name) {
        mName = name;
    }
    
    public String getName() {
        return mName;                
    }
    
    public Integer getID() {
        return mChannel.getId();                
    }
    
    public Channel getChannel() {
        return mChannel;                
    }
}
