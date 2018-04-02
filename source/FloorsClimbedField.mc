/** This class will get and display the number of floors climbed for the day.  The parameter list includes options for:
-	X and Y locations on the screen of type INTEGER
-	display color of type COLOR
-	display font of type FONT
The floors climbed can be displayed as the number of floors climbed, or as a percentage of the user's daily floors climbed goal.
*/

using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class FloorsClimbedField extends Ui.Drawable {

	var floors;
	var floorGoal;
	var floorPercent;
	var floorsX;
	var floorsY;
	var floorsRad;
	var floorsColor;
	var floorsFont;
	
	function initialize(pfloorsX, pfloorsY, pfloorsRad, pfloorsFont, pfloorsColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		floors = 0;
		floorGoal = 0;
		floorPercent = 0;
		floorsX = pfloorsX;
		floorsY = pfloorsY;
		floorsRad = pfloorsRad;
		floorsColor = pfloorsColor;
		floorsFont = pfloorsFont;
	}
	
	function draw(dc) {
		floors = ActMon.getInfo().floorsClimbed;
		Helper.drawColorCircle(dc, floorsX, floorsY, floorsRad, Ui.loadResource(Rez.Drawables.FloorsIcon), floors.toString(), floorsFont, floorsColor);
	}
	
	function drawPercent(dc) {
		floors = ActMon.getInfo().floorsClimbed;
		floorGoal = ActMon.getInfo().floorsClimbedGoal;
		if (floorGoal > 0) {
			floorPercent = (floors.toDouble()/floorGoal.toDouble()) * 100;
		}
		Helper.drawColorCircle(dc, floorsX, floorsY, floorsRad, Ui.loadResource(Rez.Drawables.FloorsIcon), floorPercent.toNumber().toString() + "%", floorsFont, floorsColor);
	}
}