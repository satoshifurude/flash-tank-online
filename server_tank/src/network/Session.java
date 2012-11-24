/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package network;

import java.net.Socket;

/**
 *
 * @author ThanhTri
 */
public class Session {
    String user;
    Handler handler;
    Socket socket;
    String hostUDP;
    int portUDP;
    public int id;
    enum Status
    {
            NOT_CONNECTED, CONNECTING, CONNECTED,CLOSED
    }
    public void setHandler (Handler handler){
        
    }
//    public void setUDP ()
}
