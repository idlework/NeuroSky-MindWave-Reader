package events
{
	import flash.events.Event;
	
	public class BrainControllerEvent extends Event
	{
		static public const DOUBLE_BLINK:String = "doubleBlink";
		static public const TIME_OUT:String = "timeOut";
		static public const CONNECTED:String = "connected";
		
		public function BrainControllerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new BrainControllerEvent(type, bubbles, cancelable);
		}
	}
}