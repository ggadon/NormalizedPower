using Toybox.WatchUi;
using Toybox.System;

class NormalizedPowerView extends WatchUi.SimpleDataField {
	var model;
	var active;
	var lastResult;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "NP";
        model = new NormalizedPowerModel();
        active = false;
        lastResult = "---";
    }
    
    function compute(info) {
    	if (active) {
    		lastResult = model.tick(info);
    	}
    	
    	return lastResult;
    }
    
    function onTimerStart() {
    	active = true;
    }
 	
 	function onTimerStop() {
 		active = false;
 		lastResult = "---";
 		model.reset();
 	}
 	
 	function onTimerResume() {
 		active = true;
 	}
 	
 	function onTimerPause() {
 		active = false;
 	}
}