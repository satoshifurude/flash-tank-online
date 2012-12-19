/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FrameWork;

/**
 *
 * @author ThanhTri
 */
public class GameDefine {
    public static final short CMD_LOGIN         = 1;
    public static final short CMD_LOGIN_FAIL    = 10;
    public static final short CMD_LOGIN_SUCCESS = 11;
    public static final short CMD_CREATE_ROOM   = 2;
    public static final short CMD_JOIN_ROOM     = 3;
    public static final short CMD_READY         = 4;
    public static final short CMD_START_GAME    = 5;
    public static final short CMD_START_GAME_SUCCESS    = 51;
    public static final short CMD_UPDATE_GAME         = 21;
    public static final short CMD_FIRE          = 22;
    public static final short CMD_QUIT_GAME     = 7;
    public static final short CMD_DISCONNECT    = 8;
    public static final short CMD_CREATE_ROOM_SUCCESS   = 31;
    public static final short CMD_GET_LIST_ROOM  = 32;
    public static final short CMD_LEAVE_ROOM  = 33;
    public static final short CMD_JOIN_ROOM_SUCCESS  = 34;
    public static final short CMD_JOIN_ROOM_NEWBIE  = 35;
    public static final short CMD_JOIN_ROOM_OLDBIE  = 36;
    
    public static final short INPUT_LEFT        = 1;
    public static final short INPUT_RIGHT       = 2;
    public static final short INPUT_UP          = 3;
    public static final short INPUT_DOWN        = 4;
    public static final short INPUT_FIRE        = 5;
    public static final short INPUT_SPECIAL_1   = 6;
    public static final short INPUT_SPECIAL_2   = 7;
    public static final short INPUT_SPECIAL_3   = 8;
    public static final short INPUT_SPECIAL_4   = 9;
    public static final short INPUT_SPECIAL_5   = 10;
    
    public static final short MAX_PLAYER_IN_ROOM   = 4;
}
