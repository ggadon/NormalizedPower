using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

class NormalizedPowerView extends WatchUi.DataField {
	var totalModel;
	var lapModel;
	var active;
	var lastTotalResult;
	var lastLapResult;

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();
        totalModel = new NormalizedPowerModel();
        lapModel = new NormalizedPowerModel();
        active = false;
        lastTotalResult = -1;
        lastLapResult = -1;
    }
    
    function onLayout(dc) {
        View.setLayout(Rez.Layouts.Main(dc));
    }
    
    function compute(info) {
    	if (active) {
    		lastTotalResult = totalModel.tick(info);
    		lastLapResult = lapModel.tick(info);
    	}
    }
    
    function onTimerStart() {
    	active = true;
    }
 	
 	function onTimerStop() {
 		active = false;
 		lastTotalResult = -1;
        lastLapResult = -1;
 		totalModel.reset();
 		lapModel.reset();
 	}
 	
 	function onTimerResume() {
 		active = true;
 	}
 	
 	function onTimerPause() {
 		active = false;
 	}
 	
 	function onTimerLap() {
		lapModel.reset();
	}
 	
 	function onUpdate(dc) {
 		var totalValue = View.findDrawableById("TotalNPValueLabel");
 		totalValue.setText(lastTotalResult != -1 ? lastTotalResult.format("%d") : "---");
 		
 		var lapValue = View.findDrawableById("LapNPValueLabel");
 		lapValue.setText(lastLapResult != -1 ? lastLapResult.format("%d") : "---");
 		
 		View.onUpdate(dc);
 	}
}