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
    
    public User(Channel channel) {
        mChannel = channel;                
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
}
