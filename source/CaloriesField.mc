/**	The following class will calculate and display the user's total calories burned for the day.  The following are parameter options:
	-	X and Y locations on user screen of type INTEGER
	-	display font of type FONT
	-	display color of type COLOR
*/


using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class CaloriesField extends Ui.Drawable {

	var cals;
	var calsX;
	var calsY;
	var calsRad;
	var calsFont;
	var calsColor;
	
	function initialize(pcalsX, pcalsY, pcalsRad, pcalsFont, pcalsColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		cals = 0;
		calsX = pcalsX;
		calsY = pcalsY;
		calsRad = pcalsRad;
		calsFont = pcalsFont;
		calsColor = pcalsColor;
	}
	
	function draw(dc) {
		var strCals = "";
		cals = ActMon.getInfo().calories;
		if (cals != null) {
			strCals = cals.toString();
		} else {
			strCals = "--";
		}
		Helper.drawColorCircle(dc, calsX, calsY, calsRad, Ui.loadResource(Rez.Drawables.CaloriesIcon), strCals, calsFont, calsColor);
	}
}