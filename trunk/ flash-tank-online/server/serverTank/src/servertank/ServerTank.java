/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servertank;

import Game.Game;
import Game.Server;

/**
 *
 * @author ThanhTri
 */
public class ServerTank {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        Game game = new Game();
        Server server = new Server();
        server.setGame(game);
        server.starServer();
    }
}
