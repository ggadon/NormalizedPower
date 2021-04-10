using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Lang;

class NormalizedPowerModel {
	var value;
	var initialized;
	
	var last30SecForthPowValues;
	var currentMovingAvgIndex;
	var currentMovingAvgForthPowerValue;
	
	var currentTotalAvgForthPowPower;
	var totalPointsCount;
	
	function initialize() {
		value = 0;
	    initialized = false;
	    
	    last30SecForthPowValues = [0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d];
	    currentMovingAvgIndex = 0;
	    currentMovingAvgForthPowerValue = 0.0d;
	    
	    currentTotalAvgForthPowPower = 0.0d;
	    totalPointsCount = 0;
	}
	
	function reset() {
		initialize();
	}
	
	// Assuming this compute is being called every 1 sec 
    function tick(info) {
    	var currPower = 0;
    	if (info has :currentPower) {
    		currPower = info.currentPower == null ? 0 : info.currentPower; 
    	}
    	
    	calcCurrentMovingAvgValue(currPower);
    	if (!initialized) {
    		// We must wait 30 seconds before NP is valid
    		return "---";
    	}
    	
    	adaptForthPoweredAvg();
    	calculateValue();
    	
        return value;
    }
    
    /*
     * 1. Calculate the forth powered value of the current power
     * 2. Adapt the moving average (remove old value, add new)
     * 3. Increase index
     */
    function calcCurrentMovingAvgValue(currentPower) {
    	var forthPoweredPowerMovingAvgPart =  Math.pow(currentPower, 4).toDouble() / 30.0d;
    	currentMovingAvgForthPowerValue = currentMovingAvgForthPowerValue - last30SecForthPowValues[currentMovingAvgIndex] + forthPoweredPowerMovingAvgPart;
    	last30SecForthPowValues[currentMovingAvgIndex] = forthPoweredPowerMovingAvgPart;
    	currentMovingAvgIndex = (currentMovingAvgIndex + 1) % 30;
    	
    	// Will get into this if statement only on the 30th pass
    	if (!initialized && currentMovingAvgIndex == 0) {
    		System.println("Starting to track NP");
    		initialized = true;
    	}
    }
    
    /**
     * Add a new point to the total forth powered avg:
     * 1. (totalPointsCount * currentTotalAvgForthPowPower + latestMovingAvgVal) / (totalPointsCount + 1)
     * 2. totalPointsCount++;
     */
    function adaptForthPoweredAvg() {
    	if (totalPointsCount > 0) {
    		currentTotalAvgForthPowPower = (totalPointsCount * currentTotalAvgForthPowPower + currentMovingAvgForthPowerValue) / (totalPointsCount + 1);
    	} else {
    		currentTotalAvgForthPowPower = currentMovingAvgForthPowerValue;
    	}   	
    	totalPointsCount++;
    }
    
    /**
     * Forth powered sqrt of the current total avg
     */
    function calculateValue() {
    	value = Math.pow(currentTotalAvgForthPowPower, 0.25).toNumber();
    }
}