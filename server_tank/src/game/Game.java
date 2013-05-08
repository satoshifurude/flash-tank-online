/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package game;

import Game.Session;
import game.iGame;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.logging.Level;
import java.util.logging.Logger;
import network.Session;
import java.net.InetSocketAddress;
import java.nio.channels.DatagramChannel;
import java.util.Hashtable;

/**
 *
 * @author ThanhTri
 */
public class Game extends iGame {

    int gameFps;
    Thread gameLoop;
    Thread handler;
    DatagramChannel chanel;
    Hashtable<String, Session> users;

    public Game() {
        gameFps = 10;
        try {
            chanel = DatagramChannel.open();
            chanel.socket().bind(new InetSocketAddress(5000));
            gameLoop = new GameLoop();
            handler = new GameHandler(chanel);
            gameLoop.start();
            handler.start();

        } catch (IOException ex) {
            Logger.getLogger(Game.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (users == null) {
            users = new Hashtable<String, Session>();
        }

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
    }

    @Override
    public void SendMsgTo(ByteBuffer b, Session s) {
        try {
            chanel.send(b, s.getAddr());
        } catch (IOException ex) {
            Logger.getLogger(Game.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void Update() {
    }

    @Override
    public void SendMessage(ByteBuffer b) {
    }

    @Override
    public void ReceiveMessage(ByteBuffer b, InetSocketAddress addr) {
        try {
            String keySession = addr.getHostName() + ":" + addr.getPort();
            int id = b.getInt();
            switch (id) {
                case 0:
                    ByteBuffer btem = b.get(b.array(), 4, b.array().length);
                    String s = new String(btem.array());
                    System.out.println("Test:" + s);
                    break;
                case 1:
                    break;
            }
            if (users == null) {
                users = new Hashtable<String, Session>();
            }
            if (!users.containsKey(keySession)) {
                Session from = users.get(keySession);

            } else {
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
