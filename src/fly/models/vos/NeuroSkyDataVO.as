package fly.models.vos
{
	public class NeuroSkyDataVO
	{
		public var signalLevel:int;
		public var blinkStrength:int;
		
		public var attention:int;
		public var meditation:int;
		
		public var alphaLow:int;
		public var alphaHigh:int;
		public var betaLow:int;
		public var betaHigh:int;
		public var gammaLow:int;
		public var gammaHigh:int;
		public var delta:int;
		public var theta:int;
		
		public function toString():String 
		{
			return 	"signalLevel: " + signalLevel + ", " +
					"blinkStrength: " + blinkStrength + ", " +
					"attention: " + attention + ", " +
					"meditation: " + meditation + ", " +
					"delta: " + delta + ", " +
					"theta: " + theta + ", " +
					"alpha.low: " + alphaLow + ", " +
					"alpha.high: " + alphaHigh + ", " +
					"beta.low: " + betaLow + ", " +
					"beta.high: " + betaHigh + ", " +
					"gamma.low: " + gammaLow + ", " +
					"gamma.high: " + gammaHigh;
		}
	}
}