package
{
	import flash.display.Sprite;
	
	import controllers.BrainController;
	
	import events.BrainControllerEvent;
	
	import fly.events.NeuroSkyEvent;
	
	import oak.utils.dependencyInjection.DependencyInjection;
	
	import views.TutorialView;
	
	[SWF(width="480", height="480", frameRate="24", backgroundColor="0x232323")]
	public class Main extends Sprite
	{
		private var _injector:DependencyInjection;
		private var _reader:BrainController;
		
		private var _tutorial:TutorialView;
		
		public function Main()
		{
			_reader = new BrainController();
			_reader.addEventListener(NeuroSkyEvent.UPDATE, _updateHandler);
			_reader.addEventListener(BrainControllerEvent.CONNECTED, _connectedHandler);
			_reader.addEventListener(BrainControllerEvent.TIME_OUT, _timeOutHandler);
			_reader.start();
		}
		
		private function _updateHandler(event:NeuroSkyEvent):void
		{
			// _reader.data is available
		}
		
		private function _connectedHandler(event:BrainControllerEvent):void
		{
			// headset is connected and has signal
		}
		
		private function _timeOutHandler(event:BrainControllerEvent):void
		{
			// headset got disconnected
		}
	}
}