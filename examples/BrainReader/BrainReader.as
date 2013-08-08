package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import fly.events.NeuroSkyEvent;
	import fly.models.vos.NeuroSkyDataVO;
	import fly.services.NeuroSkyReader;
	
	import views.Visualizer;
	
	[SWF(width="900", height="600", backgroundColor="0xF5F5F5", frameRate="24")]
	public class BrainReader extends Sprite
	{
		private var _data:NeuroSkyDataVO;
		
		private var _reader:NeuroSkyReader;
		
		private var _visual:Visualizer;
		private var _readout:TextField;
		
		public function BrainReader()
		{
			_visual = new Visualizer();
			addChild(_visual);
			
			_readout = new TextField();
			_readout.multiline = _readout.wordWrap = false;
			_readout.autoSize = TextFieldAutoSize.LEFT;
			_readout.y = stage.stageHeight - 20;
			addChild(_readout);
			
			_reader = new NeuroSkyReader();
			_reader.addEventListener(NeuroSkyEvent.UPDATE, _updateHandler);
			_reader.start();
		}
		
		private function _updateHandler(event:NeuroSkyEvent):void
		{
			_data = event.data;
			
			_readout.text = _data.toString();
			
			_visual.update(_data);
		}
	}
}