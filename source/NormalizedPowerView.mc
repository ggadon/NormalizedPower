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
        lastResult = 0;
    }
    
    function compute(info) {
    	if (active) {
    		lastResult = model.compute(info);
    	}
    	
    	return lastResult;
    }
    
    function onTimerStart() {
    	System.println("Starting timer");
    	active = true;
    }
 	
 	function onTimerStop() {
 		System.println("Stopping timer");
 		active = false;
 		lastResult = 0;
 		model.reset();
 	}
 	
 	function onTimerResume() {
 		System.println("Resuming");
 		active = true;
 	}
 	
 	function onTimerPause() {
 		System.println("Pausing");
 		active = false;
 	}
}