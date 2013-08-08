package fly.services
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import fly.constants.NeuroSkyReaderDataTypes;
	import fly.controllers.NeuroSkyDataParser;
	import fly.events.NeuroSkyEvent;
	import fly.models.vos.NeuroSkyDataVO;
	
	[Event(name=NeuroSkyEvent.UPDATE, type="fly.events.NeuroSkyEvent")]
	
	public class NeuroSkyReader extends Socket
	{
		static public const HOST:String = "127.0.0.1";
		static public const PORT:int = 13854;
		
		private var _host:String;
		private var _port:int;
		private var _format:String;
		private var _enableRawOutput:Boolean;
		
		private var _data:NeuroSkyDataVO;
		
		public function NeuroSkyReader(host:String = HOST, port:int = PORT, format:String = "json", enableRawOutput:Boolean = false)
		{
			_host = host;
			_port = port;
			_format = format;
			_enableRawOutput = enableRawOutput;
			
			if(_format != NeuroSkyReaderDataTypes.BINARY && _format != NeuroSkyReaderDataTypes.JSON)
			{
				throw new ArgumentError("Invalid type setting. Use NeuroSkyReaderDataTypes class for the correct datatypes");
			}
		}
		
		private function _createEventListeners():void
		{
			addEventListener(ProgressEvent.SOCKET_DATA, _socketDataHandler);
			addEventListener(IOErrorEvent.IO_ERROR, _errorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, _errorHandler);
		}
		
		private function _removeEventListeners():void
		{
			removeEventListener(ProgressEvent.SOCKET_DATA, _socketDataHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, _errorHandler);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _errorHandler);
		}
		
		private function _socketDataHandler(event:ProgressEvent):void
		{
			switch (_format)
			{
				case NeuroSkyReaderDataTypes.JSON:
				{
					_parseDataJson();
					break;
				}
				case NeuroSkyReaderDataTypes.BINARY:
				{
					_parseDataBinary();
					break;
				}
			}
			
			flush();
			
			dispatchUpdateEvent();
		}
		
		private function _errorHandler(event:Event):void
		{
			trace(event.type);
		}
		
		private function _parseDataJson():void
		{
			_data = NeuroSkyDataParser.json(readUTFBytes(bytesAvailable));
		}
		
		private function _parseDataBinary():void
		{
			var ba:ByteArray = new ByteArray();
			ba.position = 1;
			ba.endian = Endian.BIG_ENDIAN;
			
			readBytes(ba, 0, bytesAvailable);
			
			_data = NeuroSkyDataParser.binary(ba);
		}
		
		private function dispatchUpdateEvent():void
		{
			var event:NeuroSkyEvent = new NeuroSkyEvent(NeuroSkyEvent.UPDATE);
			event.data = _data;
			dispatchEvent(event);
		}
		
		private function _setConfiguration():void
		{
			var configuration : Object = new Object( );
			configuration["enableRawOutput"] = _enableRawOutput;
			configuration["format"] = _format;
			
			writeUTFBytes(JSON.stringify(configuration));
		}
		
		public function start():void
		{
			_createEventListeners();
			connect(_host, _port);
			_setConfiguration();
		}
		
		public function stop():void
		{
			close();
			_removeEventListeners();
		}
		
		public function get data():NeuroSkyDataVO
		{
			return _data;
		}
	}
}