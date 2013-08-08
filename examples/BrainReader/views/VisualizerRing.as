package views
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class VisualizerRing extends Sprite
	{
		private var _bm:Bitmap;
		private var _bmd:BitmapData;
		private var _canvas:Shape;
		private var _offset:Matrix;
		
		private var _lineThickness:uint = 1;
		private var _lineColor:uint = 0;
		private var _lineAlpha:Number = .3;
		private var _circleSize:int = 75;
		
		public function VisualizerRing()
		{
			_offset = new Matrix(1, 0, 0, 1, 450, 300);
			
			_canvas = new Shape();
			_canvas.x = 450;
			_canvas.y = 300;
			
			_bmd = new BitmapData(900, 600);
			
			_bm = new Bitmap(_bmd, PixelSnapping.AUTO, true);
			addChild(_bm);
		}
		
		public function update(data:Vector.<Object>):void
		{
			_canvas.graphics.clear();
			_canvas.graphics.moveTo(0, -_circleSize);
			_canvas.graphics.lineStyle(_lineThickness, _lineColor, _lineAlpha);
			
			var entry:Object;
			var level:Number = 0;
			var point:Point = new Point();
			
			for (var i : uint = 0; i < 12 ; i++)
			{
				entry = data[i];
				level = entry["data"];
				
				point.x = -Math.sin(i / 6 * Math.PI) * _circleSize * (level + 1);
				point.y = Math.cos(i / 6 * Math.PI) * _circleSize * (level + 1);
				
				if (i == 0)
				{
					_canvas.graphics.moveTo(point.x, point.y);
				} else
				{
					_canvas.graphics.lineTo(point.x, point.y);
				}
				
				_canvas.graphics.beginFill(entry["colour"], .4);
				_canvas.graphics.drawCircle(point.x, point.y, 10);
				_canvas.graphics.moveTo(point.x, point.y);
				
				if (i == 11)
				{
					entry = data[0];
					level = entry["data"];
					_canvas.graphics.lineTo( -Math.sin( 0 / 6 * Math.PI ) * _circleSize * (level + 1), Math.cos( 0 / 6 * Math.PI ) * _circleSize * (level + 1) );
				}
			}
			
			_bmd.draw(_canvas, _offset);
		}
	}
}