package network
{
	// #include "ResourceManifest.h"
	// #include "DefinesRes.h"
//	#include "DefinesSrc.h"
	

		
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
//	import com.adobe.crypto.*;
	import flash.external.ExternalInterface;
	
//	#define 	BIN_MESSAGE_TYPE_MASK				0
//	#define 	SERVER_PROTOCOL_VERSION				1
//	#define 	SIZE_OF_INT							4
//	#define		TIMEOUT								8000	//8 second
	
	public class CSockConnection
	{
		private var _game:Game = null;
		private  var _socket:Socket = null;
		private var _ip:String = null;
		private var _port:int = 0;
		private var _lastDataLen:int = 0;
		// private var _queue:Vector.<ByteArray> = null;
		
		public var _response:ByteArray = new ByteArray();
		
		// public var _lstReponse:Vector.<ByteArray> = null;;
		
		public function CSockConnection(ip:String, port:int)
		{
//			_game = game;
			_socket = new Socket();
			// _queue = new Vector.<ByteArray>();
			// _lstReponse = new Vector.<ByteArray>();
			
			//TODO: add client load balance
			_port = port;
			_ip = ip;
			Connect();
			trace("[CSockConnection constructor] = " + _ip + ":" + _port);
		}
		
		public function isConnected():Boolean
		{
			return _socket && _socket.connected;
		}
		
		public function Connect():void
		{
			if(_socket && !_socket.connected)
			{
				_socket.addEventListener(Event.CLOSE, CloseHandler);
				_socket.addEventListener(Event.CONNECT, ConnectHandler);
				_socket.addEventListener(ProgressEvent.SOCKET_DATA, DataHandler);
				
				_socket.addEventListener(IOErrorEvent.IO_ERROR, IoErrorHandler);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
				// _socket.addEventListener(Event.DISCONNECT, DisconnectHandler);
				
				_socket.connect(_ip, _port);
				trace("[CSockConnection]_socket.sendconnect send and wait for return");
			}
		}
		
		public function CloseConnect():void
		{
			if (_socket != null)
			{
				trace("[CSockConnection] Socket_Close");
				_socket.close();
			}
		}
		/*
		private function Send(bytes:ByteArray):void
		{
		if(_socket && _socket.connected)
		{
		trace("[CSockConnection] Socket_Send: " + _socket.connected);
		
		//write header
		var msg:ByteArray = new ByteArray();			
		msg.writeBytes(bytes);
		
		//send data
		_socket.writeBytes(msg);
		_socket.flush();
		}
		}
		*/
		public function Write(bytes:ByteArray):void
		{
			// _queue.push(bytes);
			
			// Flush();
			if(_socket && _socket.connected && bytes && bytes.length)
			{
				_socket.writeBytes(bytes);
				_socket.flush();
			}
			else
			{
				trace("Write - Socket not ready!!!");
			}
		}
		
		// private function Flush():void
		// {
		// if (_queue.length > 0)
		// Send(_queue.shift());
		// }
		
		private function CloseHandler(event:Event):void
		{
			trace("CloseHandler");
			_socket.close();
//			if(_game!=null)
//				_game.handleDisConnect(0, OBJUTIL.getMsgServerError());
		} 
		
		private function ConnectHandler(event:Event):void
		{	
//			if(_game != null)
//				_game.handleConnect();
			trace("[CSockConnection] Socket_ConnectHandler: " + event);
		}
		
		private function DataHandler(event:ProgressEvent):void
		{
			_socket.readBytes(_response, _response.length);
			// trace("[CSockConnection] DataHandler: len=" + _response.length + ";content=" + _response.toString());
//			if(_game != null)
//			{
				while(_response.bytesAvailable > 2)
				{				
					var msglen:int = _response.readUnsignedShort();
					if(_response.bytesAvailable >= msglen)
					{
						// trace("[CSockConnection] Socket_DataHandler: Full message receive [msglen=" + msglen + ";available=" + _response.bytesAvailable + "]");
						var message:ByteArray = new ByteArray();
						_response.readBytes(message, 0, msglen);
//						if(_game != null)
//							_game.handleMessage(message);
						// trace("[CSockConnection] Socket_DataHandler: response remain=" + _response.bytesAvailable);
						var restData:ByteArray = new ByteArray();
						if(_response.bytesAvailable > 0) //nodata to handle
							_response.readBytes(restData);
						_response = restData;
					}
					else
					{
						// trace("[CSockConnection] Socket_DataHandler: Lag message receive [msglen=" + msglen + ";available=" + _response.bytesAvailable + "]");
						_response.position -= 2;
						break;
					}
				}
//			}
//			else
//			{
//				_response.clear();
//			}
		}
		
		
		private function IoErrorHandler(event:IOErrorEvent):void
		{
			trace("[CSockConnection] Socket_IoErrorHandler: " + event);
			_socket.close();
//			if(_game!=null)
//				_game.handleDisConnect(1, OBJUTIL.getMsgServerError());
		}
		
		private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
			_socket.close();
//			if(_game!=null)
//				_game.handleDisConnect(2, OBJUTIL.getMsgServerError());
			trace("[CSockConnection] Socket_SecurityErrorHandler: " + event);
		}
		
		private function DisconnectHandler(event:Event):void
		{
			_socket.close();
//			if(_game!=null)
//				_game.handleDisConnect(3, OBJUTIL.getMsgServerError());
		}
	}

}