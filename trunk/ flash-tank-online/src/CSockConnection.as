package
{
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;
	
	public class CSockConnection
	{
		private var _game:Game = null;
		private  var _socket:Socket = null;
		private var _ip:String = null;
		private var _port:int = 0;
		private var _lastDataLen:int = 0;
		
		public var _response:ByteArray = new ByteArray();
		
		public function CSockConnection(ip:String, port:int)
		{
			_socket = new Socket();
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

		public function Write(bytes:ByteArray):void
		{
			if(_socket && _socket.connected && bytes && bytes.length)
			{
				_socket.writeBytes(bytes);
				_socket.flush();
				trace("send message = " + bytes);
			}
			else
			{
				trace("Write - Socket not ready!!!");
			}
		}

		private function CloseHandler(event:Event):void
		{
			trace("CloseHandler");
			_socket.close();
		} 
		
		private function ConnectHandler(event:Event):void
		{       
			Game.getInstance().connectSuccess();
			trace("Connect Success !!!");
		}
		
		private function DataHandler(event:ProgressEvent):void
		{
			trace("data handler");
			_socket.readBytes(_response, _response.length);
			Game.getInstance().handleMessage(_response);
			_response.clear();
		}
		
		
		private function IoErrorHandler(event:IOErrorEvent):void
		{
			trace("[CSockConnection] Socket_IoErrorHandler: " + event);
			_socket.close();
		}
		
		private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
			_socket.close();
			trace("[CSockConnection] Socket_SecurityErrorHandler: " + event);
		}
		
		private function DisconnectHandler(event:Event):void
		{
			_socket.close();
		}
	}
}