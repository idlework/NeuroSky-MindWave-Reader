package fly.controllers
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import fly.constants.NeuroSkyByteTypes;
	import fly.models.vos.NeuroSkyDataVO;

	public class NeuroSkyDataParser extends EventDispatcher
	{
		static private var _instance:NeuroSkyDataParser;	
		
		static public function get instance():NeuroSkyDataParser
		{
			if (!_instance)
			{
				_instance = new NeuroSkyDataParser(new Singleton());
			}
			
			return _instance; 
		}
		
		private var _vo:NeuroSkyDataVO;
		
		public function NeuroSkyDataParser(singleton:Singleton)
		{
			
		}
		
		static public function json(data:String):NeuroSkyDataVO
		{
			return instance.json(data);
		}
		
		public function json(data:String):NeuroSkyDataVO
		{
			_vo = new NeuroSkyDataVO();
			
			var packets:Array = data.split(/\r/);
			var entry:Object;
			
			for each (var packet:String in packets)
			{        
				if(packet.length)
				{
					entry = JSON.parse(packet);
					
					if(entry.hasOwnProperty("poorSignalLevel"))
					{
						_vo.signalLevel = entry["poorSignalLevel"];
						
						if(_vo.signalLevel == 0)
						{
							_vo.attention = entry["eSense"]["attention"];
							_vo.meditation = entry["eSense"]["meditation"];
							
							_vo.alphaLow = entry["eegPower"]["lowAlpha"];
							_vo.alphaHigh = entry["eegPower"]["highAlpha"];
							_vo.betaLow = entry["eegPower"]["lowBeta"];
							_vo.betaHigh = entry["eegPower"]["highBeta"];
							_vo.gammaLow = entry["eegPower"]["lowGamma"];
							_vo.gammaHigh = entry["eegPower"]["highGamma"];
							_vo.delta = entry["eegPower"]["delta"];
							_vo.theta = entry["eegPower"]["theta"];
						} else
						{
							_vo.signalLevel = 200;
						}
					} else if (entry.hasOwnProperty("blinkStrength"))
					{
						_vo.blinkStrength = entry["blinkStrength"];
					}
				}
				
				entry = null;
			}
			
			return _vo;
		}
		
		static public function binary(data:ByteArray):NeuroSkyDataVO
		{
			return instance.binary(data);
		}
		
		public function binary(data:ByteArray):NeuroSkyDataVO
		{
			_vo = new NeuroSkyDataVO();
			
			while (twoBytesSeen(data))
			{
				continue;
			}
			
			while (isNotEndOfBuffer(data)) 
			{
				_processByte(data);
			}
			
			return _vo;
		}
		
		private function _processByte(data:ByteArray):void
		{
			var codeByte:uint = data.readUnsignedByte();
			var dataByte:uint = data.readUnsignedByte();
			
			if (NeuroSkyByteTypes.isSignalQualityByte(codeByte))
			{
				_vo.signalLevel = dataByte;
			}
			else if (NeuroSkyByteTypes.isAttentionByte(codeByte))
			{
				_vo.attention = dataByte;
			}
			else if (NeuroSkyByteTypes.isMeditationByte(codeByte))
			{
				_vo.meditation = dataByte;
			}
			else if (NeuroSkyByteTypes.isEEGPowersByte(codeByte))
			{
//				var lengthByte:Number = dataByte;
//				eegPowers.parseEEGPowers(data);
				
				_vo.delta = data.readFloat();
				_vo.theta = data.readFloat();
				_vo.betaLow = data.readFloat();
				_vo.betaHigh = data.readFloat();
				_vo.alphaLow = data.readFloat();
				_vo.alphaHigh = data.readFloat();
				_vo.gammaLow = data.readFloat();
				_vo.gammaHigh = data.readFloat();
			}
		}
		
		static public function twoBytesSeen(data:ByteArray):Boolean
		{
			return (isNotEndOfBuffer(data) && currentByteIsNotSyncByte(data) && lastByteIsNotSyncByte(data)); 
		}   
		
		static public function isNotEndOfBuffer(data:ByteArray):Boolean
		{
			return data.position < data.length;
		}
		
		static public function currentByteIsNotSyncByte(data:ByteArray):Boolean
		{
			var currentByte:uint = data.readUnsignedByte();
			return byteIsNotSyncByte(currentByte);
		}
		
		static public function lastByteIsNotSyncByte(data:ByteArray):Boolean
		{
			var lastByte:uint = data.position - 1;
			return byteIsNotSyncByte(lastByte);
		}
		
		static public function byteIsNotSyncByte(byte:uint):Boolean
		{
			return byte != NeuroSkyByteTypes.SYNC;
		}

		static public function get data():NeuroSkyDataVO
		{
			return instance.data;
		}
		
		public function get data():NeuroSkyDataVO
		{
			return _vo;
		}
	}
}

class Singleton
{
}