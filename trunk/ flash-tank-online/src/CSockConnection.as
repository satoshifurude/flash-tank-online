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
			trace("[CSockConnection] Socket_ConnectHandler: " + event);
			trace("Connect Success !!!");
		}
		
		private function DataHandler(event:ProgressEvent):void
		{
			_socket.readBytes(_response, _response.length);
			while(_response.bytesAvailable > 2)
			{                               
				var msglen:int = _response.readUnsignedShort();
				if(_response.bytesAvailable >= msglen)
				{
					var message:ByteArray = new ByteArray();
					_response.readBytes(message, 0, msglen);
					var restData:ByteArray = new ByteArray();
					if(_response.bytesAvailable > 0) //nodata to handle
							_response.readBytes(restData);
					_response = restData;
				}
				else
				{
					_response.position -= 2;
					break;
				}
			}
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