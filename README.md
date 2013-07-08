NeuroSky-MindWave-Reader
========================

With this small library you are able to read out the MindWave. All possible data from the Neurosky Mindwave is accessible with this library.

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

When the connection is made the trace will show:
signalLevel: 0,
blinkStrength: 0,
delta: 2086924,
theta: 606761,
alpha.low: 90391,
alpha.high: 171140,
beta.low: 96183,
beta.high: 216451,
gamma.low: 109903,
gamma.high: 29423

To do
=====

Add an example application to the repository.