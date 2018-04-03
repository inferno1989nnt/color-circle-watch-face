/**
	Garmin watchface that displays the following:
	-	4 of the following data fields (selected by user)
		    0 Alarms
            1 Notifications
            2 Battery
            3 HeartRate                        
            4 StepCount
            5 StepCountPercent
            6 Calories
            7 Elevation (ft or meters, dependent on user's watch settings)
            8 Distance (mi or km, dependent on user's watch settings)
            9 DailyActiveMinutes
            10 DailyActiveMinutesPercent (based off a goal of 1/7th the weekly goal)
            11 WeeklyActiveMinutes
            12 WeeklyActiveMinutesPercent
            13 FloorsClimbed
            14 FloorsClimbedPercent
	-	date (format selected by user)
	        0 DayMonDD
            1 DayDDMon
            2 MonDD
			3 DDMon
            4 MM/DD/YYYY
            5 DD/MM/YYYY
	-	time (12 or 24 hour format, dependant on user's watch settings)
	-	color for each data field display, time, date and logo
			0 ColorWhite                        
            1 ColorGray
            2 ColorRed
            3 ColorDarkRed
            4 ColorOrange
            5 ColorYellow
            6 ColorGreen
            7 ColorDarkGreen
            8 ColorBlue
            9 ColorDarkBlue
            10 ColorPurple
            11 ColorPink
	-	bluetooth connection to phone (user selects feature on/off)
			0 Bluetooth Indicator not Present
			1 Bluetooth Indicator Present

created on: Sept. 25, 2017
updated on: Jan. 4, 2018
current version: 2.1.1
created by: 
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Background;

class ColorCirclesView extends Ui.WatchFace {
	//user selected data fields to display
	var PROP_FIELDS = new [8];
	var fieldProperties = ["Field1", "Field2", "Field3", "Field4", "Field5", "Field6", "Field7", "Phone"];
	var icons = new [9];
	
	//user selected colors
	var PROP_COLORS = new [9];
	var colorProperties = ["Circle1Color", "Circle2Color", "Circle3Color", "Circle4Color", "Circle5Color", "Circle6Color", "Circle7Color", "TimeColor", "DateColor"];
	var colorNum = null;
	
	//user selected date layout
	var PROP_DATE_FORMAT = 0;
	
	//locations of data fields, icons, time and date
	var bluetoothLocation = new[2];
	var circleXLocations = new [7];
	var circleYLocations = new [7];
	var dateLocation, timeLocation = new [2];
	
	//size of each data "bubble"
	var circleRadius = new [7];
	
	//fonts	
	var dateFont = null;
	var timeFont = null;
	var sysFont = null;
	
    function initialize() {
    	WatchFace.initialize();
    	//initialize property variables (user selections)
    	//default values are notifications, battery life, calories, step count as a percent, bluetooth indicator present
    	//initialize all colors to blue

    	for (var i = 0; i<PROP_COLORS.size(); i++) {
    		PROP_COLORS[i] = Gfx.COLOR_BLUE;
    	}
		//get user selections for display fields, colors and date format  
    	for (var i = 0; i<PROP_FIELDS.size(); i++) {
			PROP_FIELDS[i] = Application.getApp().getProperty(fieldProperties[i]);
    	}
    	
    	for (var i = 0; i<PROP_COLORS.size(); i++) {
    		colorNum = Application.getApp().getProperty(colorProperties[i]);
    		PROP_COLORS[i]  = returnColor(colorNum);
    	}
    	
    	PROP_DATE_FORMAT = Application.getApp().getProperty("DateFormat");
    }

    function onLayout(dc) {
		setLocations(dc);
		loadIcons(dc);
    }

    function onShow() {	}

    function onUpdate(dc) {
    	//set background to black, and clear
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
		dc.setPenWidth(3);
		
		//draw the bluetooth icon
		if (PROP_FIELDS[7] == 1) {
			if (System.getDeviceSettings().phoneConnected == true) {
				dc.drawBitmap(bluetoothLocation[0], bluetoothLocation[1], icons[7]);
			} else {
				dc.drawBitmap(bluetoothLocation[0], bluetoothLocation[1], icons[8]);
			}
		}
		
		//draw the time
		var time = new TimeField(timeLocation[0], timeLocation[1], timeFont, PROP_COLORS[7]);
		time.draw(dc);
		
		//draw the date
		var date = new DateField(dateLocation[0], dateLocation[1], dateFont, PROP_COLORS[8], PROP_DATE_FORMAT);
		date.draw(dc);
		
		//draw data fields, with no default
		for (var i = 0; i<circleXLocations.size(); i++) {
			switch (PROP_FIELDS[i]) {
				case 0:
					var alarm = new AlarmField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					alarm.draw(dc);
					break;
				case 1:
					var messages = new MessageField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					messages.draw(dc);
					break;
				case 2:
					var battery = new BatteryField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					battery.draw(dc);
					break;
				case 3:
					var heartRate = new HeartRateField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					heartRate.draw(dc);
					break;
				case 4:
					var steps = new StepsField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					steps.draw(dc);
					break;
				case 5:
					var stepsPer = new StepsField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					stepsPer.drawPercent(dc);
					break;
				case 6:
					var calories = new CaloriesField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					calories.draw(dc);
					break;
				case 7:
					var elevation = new AltitudeField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					elevation.draw(dc);
					break;
				case 8:
					var distance = new DistanceField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					distance.draw(dc);
					break;
				case 9:
					var activeMinDay = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i], 0, 0);
					activeMinDay.draw(dc);
					break;
				case 10:
					var activeMinWeek = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i], 0, 1);
					activeMinWeek.draw(dc);
					break;
				case 11:
					var activeMinDayPer = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i], 1, 0);
					activeMinDayPer.draw(dc);
					break;
				case 12:
					var activeMinWeekPer = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i], 1, 1);
					activeMinWeekPer.draw(dc);
					break;
				case 13:
					var floors = new FloorsClimbedField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					floors.draw(dc);
					break;
				case 14:
					var floorsPercent = new FloorsClimbedField(circleXLocations[i], circleYLocations[i], circleRadius[i], sysFont, PROP_COLORS[i]);
					floorsPercent.drawPercent(dc);
					break;					
				default:
					break;
			}
		}
    }

    function onHide() {	}

    function onExitSleep() {	}

    function onEnterSleep() {	}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////HELPER FUNCTIONS///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/** This function takes the number from user selection and translates to the appropriate color.  
		Only Garmin native colors are included. */    
    
    function returnColor(colorNum) {
    	switch(colorNum) {
    		case 0:
    			return Gfx.COLOR_WHITE;
    			break;
    		case 1:
    			return Gfx.COLOR_LT_GRAY;
    			break;
    		case 2:
    			return Gfx.COLOR_RED;
    			break;
    		case 3:
    			return Gfx.COLOR_DK_RED;
    			break;
    		case 4:
    			return Gfx.COLOR_ORANGE;
    			break;
    		case 5:
    			return Gfx.COLOR_YELLOW;
    			break;
    		case 6:
    			return Gfx.COLOR_GREEN;
    			break;
    		case 7:
    			return Gfx.COLOR_DK_GREEN;
    			break;
    		case 8:
    			return Gfx.COLOR_BLUE;
    			break;
    		case 9:
    			return Gfx.COLOR_DK_BLUE;
    			break;
    		case 10:
    			return Gfx.COLOR_PURPLE;
    			break;
    		case 11:
    			return Gfx.COLOR_PINK;
    			break;
    		default:
    			return Gfx.COLOR_WHITE;
    			break;
		}
	}

	/** This function loads the appropriate icon based upon the user selections.
		Steps and Steps as a percent share an icon.
		Active Minutes Daily, Weekly and as a percent share an icon.
		Floors Complete and as a percent share an icon.
		Default is a transparent icon. */	
	function loadIcons(dc){
	
		icons[icons.size()-2] = Ui.loadResource(Rez.Drawables.PhoneIcon);
		icons[icons.size()-1] = Ui.loadResource(Rez.Drawables.NoPhoneIcon);
		
		for (var i=0; i<icons.size()-2; i++) {//last two for bluetooth icons
			switch (PROP_FIELDS[i]) {
				case 0:
					icons[i] = Ui.loadResource(Rez.Drawables.AlarmIcon);
					break;
				case 1:
					icons[i] = Ui.loadResource(Rez.Drawables.MessageIcon);
					break;
				case 2:
					icons[i] = Ui.loadResource(Rez.Drawables.BatteryIcon);
					break;
				case 3:
					icons[i] = Ui.loadResource(Rez.Drawables.HeartRateIcon);
					break;
				case 4:
				case 5:
					icons[i] = Ui.loadResource(Rez.Drawables.StepsIcon);
					break;
				case 6:
					icons[i] = Ui.loadResource(Rez.Drawables.CaloriesIcon);
					break;
				case 7:
					icons[i] = Ui.loadResource(Rez.Drawables.ElevationIcon);
					break;
				case 8:
					icons[i] = Ui.loadResource(Rez.Drawables.DistanceIcon);
					break;
				case 9:
				case 10:
				case 11:
				case 12:
					icons[i] = Ui.loadResource(Rez.Drawables.MinutesIcon);
					break;
				case 13:
				case 14:
					icons[i] = Ui.loadResource(Rez.Drawables.FloorsIcon);
					break;
				default:
					icons[i] = Ui.loadResource(Rez.Drawables.NullIcon);
					break;
			}
		}
	}
	
	/** This function sets locations and fonts based upon the watch shape and size. */
	function setLocations(dc) {
		// Default font
    	timeFont = Ui.loadResource(Rez.Fonts.TB40);
    	dateFont = Ui.loadResource(Rez.Fonts.TB20);
		sysFont = Ui.loadResource(Rez.Fonts.TB20);
		
		if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND) {
			// SmallRound
			// Fenix 5S, Fenix Chronos
	    	if (System.getDeviceSettings().screenWidth < 220) {
	    		circleXLocations = [ 58, 112, 165, 37, 80, 130, 170 ];
    			circleYLocations = [ 40, 30, 48, 134, 176, 185, 150 ];
    			circleRadius = [ 20, 30, 25, 25, 30, 20, 30 ];
    			timeLocation = [ dc.getWidth() / 2, 70 ];
    			dateLocation = [ dc.getWidth() / 2, 110 ];
    			bluetoothLocation = [ 20, 50 ];
	    	}
	    	// LargeRound 
	    	// Approach S60, D2 Charlie, Descent Mk1, Fenix5, Fenix 5X,
	    	// Forerunner 645, Forerunner 645 music, Forerunner 935, Vivoactive 3
	    	else {
	    		circleXLocations = [ 58, 117, 179, 44, 90, 149, 193 ];
    			circleYLocations = [ 50, 35, 53, 157, 200, 205, 165 ];
    			circleRadius = [ 22, 30, 25, 25, 30, 25, 30 ];
    			timeLocation = [ dc.getWidth() / 2, 64 ];
    			dateLocation = [ dc.getWidth() / 2, 140 ];
    			bluetoothLocation = [ 15, 60 ];
    			timeFont = Ui.loadResource(Rez.Fonts.CB80);
    			dateFont = Ui.loadResource(Rez.Fonts.CB20);
    			sysFont = Ui.loadResource(Rez.Fonts.CB15);
    		}
		} else if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {
			// LongRectangle
			// There is no CIQ 2.x devices
    		if (System.getDeviceSettings().screenWidth > System.getDeviceSettings().screenHeight) {
    			circleXLocations = [ 85, 96, 175, 34, 35, 142, 170 ];
    			circleYLocations = [ 130, 31, 57, 42, 113, 27, 117 ];
    			circleRadius = [ 17, 30, 25, 25, 30, 15, 30 ];
    			timeLocation = [ dc.getWidth() / 2, 70 ];
				dateLocation = [ dc.getWidth() / 2, 95 ];
    			bluetoothLocation = [ 125, 48 ];
    			timeFont = Ui.loadResource(Rez.Fonts.TB30);
     		}
     		// TallRectangle
     		// Vivoactive HR
     		else {
     			circleXLocations = [ 15, 115, 72, 32, 34, 133, 117 ];
    			circleYLocations = [ 132, 95, 135, 176, 90, 50, 170 ];
    			circleRadius = [ 30, 30, 25, 25, 30, 13, 12 ];
    			dateLocation =  [ dc.getWidth() / 2, 45 ];
    			timeLocation = [ dc.getWidth() / 2, 10 ];
    			bluetoothLocation = [ 65, 65 ];
    		}
    	} 
    	// SemiRound
    	// Forerunner 735XT
    	else {
   		    circleXLocations = [ 21, 112, 165, 47, 105, 192, 165 ];
			circleYLocations = [ 88, 30, 48, 134, 150, 92, 141 ];
			circleRadius = [ 17, 30, 25, 25, 30, 18, 30 ];
			timeLocation = [ dc.getWidth() / 2, 71 ];
			dateLocation = [ dc.getWidth() / 2 + 1, 105 ];
			bluetoothLocation = [ 12, 49 ];
    	}

    }
     
}