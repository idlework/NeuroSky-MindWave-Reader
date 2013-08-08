package fly.constants
{
	public class NeuroSkyByteTypes
	{
		static public const SIGNAL_QUALITY:int = 0x02;
		static public const ATTENTION:int = 0x04;
		static public const MEDITATION:int = 0x05;
		static public const EEG_POWERS:int = 0x81;
		static public const SYNC:int = 0xAA;
		
		static public function isSignalQualityByte(byte:uint):Boolean
		{
			return byte == SIGNAL_QUALITY;
		}
		
		static public function isAttentionByte(byte:uint):Boolean
		{
			return byte == ATTENTION;
		}
		
		static public function isMeditationByte(byte:uint):Boolean
		{
			return byte == MEDITATION;
		}
		
		static public function isEEGPowersByte(byte:uint):Boolean
		{
			return byte == EEG_POWERS;
		}
	}
}