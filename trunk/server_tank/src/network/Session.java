/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package network;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;

/**
 *
 * @author ThanhTri
 */
public class Session {

    String user;
//    Handler handler;
//    Socket socket;
    String hostUDP;
    int portUDP;
    public int id;

    enum Status {

        NOT_CONNECTED, CONNECTING, CONNECTED, CLOSED
    }
    public Session(String hostUDP,int portUDP,String user){
        this.hostUDP = hostUDP;
        this.portUDP = portUDP;
        this.user = user;
    }
    public String getKey() {
        return hostUDP+":"+portUDP;
    }
    public InetSocketAddress getAddr(){
        InetSocketAddress result = new InetSocketAddress(hostUDP, portUDP);
        return result;
    }
    
//    public void setHandler (Handler handler){
//         
//    }
//    public void setUDP ()
}
