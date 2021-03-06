NeuroSky-MindWave-Reader
========================

With this small library you are able to read out the Neurosky MindWave. All possible data from the Neurosky Mindwave is accessible with this library. The library also gives the option for json parsing or binary parsing.

Dependencies
============
- Adobe Flash Player 9 or Adobe Air
- Thinkgear: http://developer.neurosky.com/docs/doku.php?id=thinkgear_connector_tgc

Example
=======

```ActionScript
private function _initReader():void
{
	var reader:NeuroSkyReader = new NeuroSkyReader();
	reader.addEventListener(NeuroSkyEvent.UPDATE, _updateHandler);
	reader.start();
}

private function _updateHandler(event:NeuroSkyEvent):void
{
	var vo:NeuroSkyDataVO = event.data;
	trace(vo);
}
```

When the connection is made the trace will result in:
signalLevel: 0,
blinkStrength: 91,
delta: 2086924,
theta: 606761,
alpha.low: 90391,
alpha.high: 171140,
beta.low: 96183,
beta.high: 216451,
gamma.low: 109903,
gamma.high: 29423

SignalLevel 200 means no signal from the NeuroSky MindWave and signalLevel 0 means we have a connection with the Neurosky MindWave.
