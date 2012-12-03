/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import game.iGame;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
  
/**
 *
 * @author ThanhTri
 */
public class ClientThread extends Thread {

    public SocketChannel channel;
    public boolean running;
    public ByteBuffer buffer;
    public iGame game;
//    public i
    public ClientThread(SocketChannel channel) {
        this.channel = channel;
//        this.channel.configureBlocking(true);
        buffer = ByteBuffer.allocate(1024);
        running = true;
    }

    public void StopClient() {
        try {
            channel.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public void setGame(iGame game) {
        this.game = game;
    }

    public SocketChannel getChanel() {
        return channel;
    }
    public String getKey (){
//        return channel.socket().
        return null;
    }
    public void SendMessage(ByteBuffer buffer) {
        try {
            channel.write(buffer);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public void ReceiverMessage(ByteBuffer buffer) {        
        if(game!= null ){
            game.receiverMessage(this, buffer);
        }else{
            System.out.println("Game null");
        }
    }

    @Override
    public void run() {
        while (running && channel.isConnected()) {          
            try {
                buffer.clear();
                channel.read(buffer);
                buffer.flip();
//                channel.
                if (game != null && buffer.hasRemaining()) {
                    game.receiverMessage(this, buffer);
                }
            } catch (IOException ex) {                
                ex.printStackTrace();
            }
            try {
                this.sleep(10);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }
}
