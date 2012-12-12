/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package netty_server;

import FrameWork.Game;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelPipelineCoverage;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelHandler;

/**
 *
 * @author ThanhTri
 */
@ChannelPipelineCoverage("all")
public class ClientHandler extends SimpleChannelHandler {
    @Override
    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e){
        System.out.println("New client connect ID "+e.getChannel().getId());
        Game.shareGame().channelConnected(e);
    }
//    public  v
    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
        Game.shareGame ().messageReceived(e);
    }
//    @Override
//    public void 
//    public void 
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        e.getCause().printStackTrace();        
        Channel ch = e.getChannel();
        ch.close();
    }

}
