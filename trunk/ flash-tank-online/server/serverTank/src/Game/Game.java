/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import game.iGame;
import java.nio.ByteBuffer;

/**
 *
 * @author ThanhTri
 */
public class Game extends iGame{
    Thread gameLoop;
    int mFPS;
    public Game (){
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
    public void onUpdate() {
    }

    @Override
    public void sendMessage(ClientThread toUser, ByteBuffer msg) {
        toUser.SendMessage(msg);
    }

    @Override
    public void receiverMessage(ClientThread formUser, ByteBuffer msg) {
//        int num = msg.getInt();
        System.out.println("receiver message : "+ ", msg = " + msg.getChar(0));
        
    }

    @Override
    public void addClient(ClientThread client) {
        System.out.println("has client connect game ");
    }
    
}
