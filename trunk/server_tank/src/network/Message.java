/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package network;

import java.nio.ByteBuffer;

/**
 *
 * @author ThanhTri
 */
public class Message {
    private int id;
    private ByteBuffer data;
    public Message (){
        id = 0;
        data = ByteBuffer.allocate(1024);
    }
    public Message (ByteBuffer b){
        data = ByteBuffer.allocate(1024);
        
        if(b.hasRemaining()){
            id = b.getInt();
        }
        if(b.hasRemaining()){
//             data.ge
        }
    }
    private void setID(int id){
        this.id = id;
    }
    private int getID (){
        return id;
    }
    public ByteBuffer getData (){
        return data;
    }
    public char	getChar() {
        return data.getChar();
    }
    public float getFloat(){
        return data.getFloat();
    }
    public float getInt (){
        return data.getInt();
    }
    public void put(byte[] src){
        data.put(src);
    }
    public void putChar(char value) {
        data.putChar(value); 
    }
    public void putFloat(float value) {
        data.putFloat(value) ;
    }
    public void putInt(int value) {
        data.putInt(value) ;
    }
}
