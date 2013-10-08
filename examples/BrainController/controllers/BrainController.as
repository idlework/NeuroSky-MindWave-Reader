package controllers
{
	import flash.utils.getTimer;
	
	import events.BrainControllerEvent;
	
	import fly.events.NeuroSkyEvent;
	import fly.services.NeuroSkyReader;
	
	[Event(name="connected", type="events.BrainControllerEvent")]
	[Event(name="doubleBlink", type="events.BrainControllerEvent")]
	[Event(name="timeOut", type="events.BrainControllerEvent")]
	
	public class BrainController extends NeuroSkyReader
	{
		private var _timeNow:int;
		private var _connected:Boolean;
		
		//timeout control
		static public var timeoutDuration:int = 8000;
		private var _timedOut:Boolean;
		private var _firstSignalLoss:int;
		
		//blink control
		static public var blinkInterval:int = 250;
		private var _firstBlink:int;
		private var _blinkCount:int;
		
		public function BrainController()
		{
			_init();
		}
		
		private function _init():void
		{
			addEventListener(NeuroSkyEvent.UPDATE, _updateHandler);
			
			_timedOut = true;
			_connected = false;
		}
		
		private function _updateHandler(event:NeuroSkyEvent):void
		{
			_timeNow = getTimer();
			
			_checkTimeOut();
			
			if (_timedOut) return;
			
			_checkBlinkCount();
		}
		
		private function _checkTimeOut():void
		{
			if (!_timedOut && data.signalLevel == 200)
			{
				if (_firstSignalLoss < 0)
				{
					_firstSignalLoss = _timeNow;
				} else if (_timeNow - _firstSignalLoss > timeoutDuration)
				{
					_timedOut = true;
					_connected = false;
					
					dispatchEvent(new BrainControllerEvent(BrainControllerEvent.TIME_OUT));
				}
			} else if (!_connected && data.signalLevel < 200)
			{
				if (!_connected)
				{
					_connected = true;
					_timedOut = false;
					
					dispatchEvent(new BrainControllerEvent(BrainControllerEvent.CONNECTED));
				}
				
				_firstSignalLoss = -1;
			}
		}
		
		private function _checkBlinkCount():void
		{
			if (data.blinkStrength > 10)
			{
				if (_firstBlink < 0)
				{
					_firstBlink = _timeNow;
				}
				
				_blinkCount++;
			}
			
			if (_timeNow - _firstBlink >= blinkInterval)
			{
				_firstBlink = -1;
				_blinkCount = 0;
			}
			
			if (_blinkCount >= 2)
			{
				_firstBlink = _blinkCount = 0;
				
				dispatchEvent(new BrainControllerEvent(BrainControllerEvent.DOUBLE_BLINK));
			}
		}

		override public function get connected():Boolean
		{
			return _connected;
		}

		public function get timedOut():Boolean
		{
			return _timedOut;
		}
	}
}