using Toybox.System;
using Toybox.WatchUi;

class NormalizedPowerLapView extends NormalizedPowerView {
	
	function initialize() {
		NormalizedPowerView.initialize();
		label = "Lap NP";
	}
	
	function onTimerLap() {
		model.reset();
	}
}