/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package game;

import java.nio.ByteBuffer;
import network.Session;

/**
 *
 * @author ThanhTri
 */
public class GameTank extends Game {
    int gameFps;
    Thread gameLoop;
    public GameTank (){
        gameFps = 10;
        gameLoop = new GameLoop();
        gameLoop.start();
    }

    @Override
    public void setFPS(int fps) {
        gameFps = fps;
    }

    @Override
    public int getFPS() {
        return gameFps;
    }

    @Override
    public void Multicast(ByteBuffer b) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void SendMsgTo(Session s, ByteBuffer b) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void Update() {
        System.out.println("Update game tank -- FPS:"+Game.fps+"-- delta time: "+Game.deltaTime);
    }
    
}
