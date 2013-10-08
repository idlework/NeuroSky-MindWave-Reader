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
	
	[Event(name="neuroskyEventUpdate", type="fly.events.NeuroSkyEvent")]
	
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
			_data = new NeuroSkyDataVO;
			
			if(_format != NeuroSkyReaderDataTypes.BINARY && _format != NeuroSkyReaderDataTypes.JSON)
			{
				throw new ArgumentError("Invalid type setting. Use NeuroSkyReaderDataTypes class for the correct datatypes");
			}
		}
		
		protected function createEventListeners():void
		{
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}
		
		protected function removeEventListeners():void
		{
			removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}
		
		protected function socketDataHandler(event:ProgressEvent):void
		{
			switch (_format)
			{
				case NeuroSkyReaderDataTypes.JSON:
				{
					parseDataJson();
					break;
				}
				case NeuroSkyReaderDataTypes.BINARY:
				{
					parseDataBinary();
					break;
				}
			}
			
			flush();
			
			dispatchUpdateEvent();
		}
		
		protected function errorHandler(event:Event):void
		{
			trace(event.type);
		}
		
		protected function parseDataJson():void
		{
			_data = NeuroSkyDataParser.json(readUTFBytes(bytesAvailable));
		}
		
		protected function parseDataBinary():void
		{
			var ba:ByteArray = new ByteArray();
			ba.position = 1;
			ba.endian = Endian.BIG_ENDIAN;
			
			readBytes(ba, 0, bytesAvailable);
			
			_data = NeuroSkyDataParser.binary(ba);
		}
		
		protected function dispatchUpdateEvent():void
		{
			var event:NeuroSkyEvent = new NeuroSkyEvent(NeuroSkyEvent.UPDATE);
			event.data = _data;
			dispatchEvent(event);
		}
		
		protected function setConfiguration():void
		{
			var configuration : Object = new Object( );
			configuration["enableRawOutput"] = _enableRawOutput;
			configuration["format"] = _format;
			
			writeUTFBytes(JSON.stringify(configuration));
		}
		
		public function start():void
		{
			createEventListeners();
			connect(_host, _port);
			setConfiguration();
		}
		
		public function stop():void
		{
			close();
			removeEventListeners();
		}
		
		public function get data():NeuroSkyDataVO
		{
			return _data;
		}
	}
}