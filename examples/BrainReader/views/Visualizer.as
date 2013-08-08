package views
{
	import flash.display.Sprite;
	
	import fly.models.vos.NeuroSkyDataVO;
	
	public class Visualizer extends Sprite
	{
		private var _ring:VisualizerRing;
		
		public function Visualizer()
		{
			_ring = new VisualizerRing();
			addChild(_ring);
		}
		
		public function update(vo:NeuroSkyDataVO):void
		{
			if (vo.signalLevel == 200) return;
			
			var data:Vector.<Object> = new Vector.<Object>();
			data.push({data: vo.signalLevel, colour: 0xEE1C25, label: "signalLevel"});
			data.push({data: vo.blinkStrength / 100, colour: 0xB72468, label: "blinkStrength"});
			
			data.push({data: vo.attention / 50, colour: 0x662C90, label: "attention"});
			data.push({data: vo.meditation / 50, colour: 0x524EA2, label: "meditation"});
			
			data.push({data: vo.alphaLow / 100000, colour: 0x0076B3, label: "alphaLow"});
			data.push({data: vo.alphaHigh / 100000, colour: 0x6DC8BF, label: "alphaHigh"});
			data.push({data: vo.betaLow / 100000, colour: 0x00A650, label: "betaLow"});
			data.push({data: vo.betaHigh / 100000, colour: 0xAED137, label: "betaHigh"});
			data.push({data: vo.gammaLow / 100000, colour: 0xFEF200, label: "gammaLow"});
			data.push({data: vo.gammaHigh / 100000, colour: 0xFDB813, label: "gammaHigh"});
			
			data.push({data: vo.delta / 1000000, colour: 0xF78B1F, label: "delta"});
			data.push({data: vo.theta / 1000000, colour: 0xF15A23, label: "theta"});
			
			_ring.update(data);
		}
	}
}