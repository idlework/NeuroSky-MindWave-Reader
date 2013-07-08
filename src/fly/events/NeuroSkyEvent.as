package fly.events
{
	import flash.events.Event;
	
	import fly.models.vos.NeuroSkyDataVO;
	
	public class NeuroSkyEvent extends Event
	{
		public static const UPDATE:String = "neuroskyEventUpdate";
		
		public var data:NeuroSkyDataVO;
		
		public function NeuroSkyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var event:NeuroSkyEvent = new NeuroSkyEvent(type);
			event.data = data;
			return event;
		}
	}
}