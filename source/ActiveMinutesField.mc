/** This class calculates the active minutes of the user.  The following are the options from the parameter list:

	-	location on user screen (actMinX and actMinY) INTEGER
	-	color of the active minutes (actMinColor), a Gfx. constant or custom color from resources COLOR
	-	font of the active minutes (actMinFont), a Gfx. constant or custom font from resources FONT
	-	use daily or weekly active minutes
(default)0: daily active minutes and 1/7 of weekly active minutes goal
		 1: weekly active minutes and weekly active minutes goal
	-	display active minutes complete for given time period, or as a percentage of that time period goal
(default)0: active minutes complete as integer
		 1: active minutes complete as integer percentage
*/

using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class ActiveMinutesField extends Ui.Drawable {

	var actMin;
	var actMinGoal;
	
	var actMinX;
	var actMinY;
	var actMinRad;
	var actMinColor;
	var actMinFont;
	var actMinDayOrWeek;
	var actMinAsPercent;
	
	function initialize(pactMinX, pactMinY, pactMinRad, pactMinFont, pactMinColor, pactMinDayOrWeek, pactMinAsPercent) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		actMin = 0;
		actMinGoal = 0;

		actMinX = pactMinX;
		actMinY = pactMinY;
		actMinRad = pactMinRad;
		actMinColor = pactMinColor;
		actMinFont = pactMinFont;
		actMinDayOrWeek = pactMinDayOrWeek;
		actMinAsPercent = pactMinAsPercent;
	}
	
	function draw(dc) {
		switch (actMinDayOrWeek) {
			case 1:
				actMin = ActMon.getInfo().activeMinutesWeek.total.toDouble();
				actMinGoal = ActMon.getInfo().activeMinutesWeekGoal.toDouble();
				break;
			case 0:
			default:
				actMin = ActMon.getInfo().activeMinutesDay.total;
				actMinGoal = (ActMon.getInfo().activeMinutesWeekGoal.toDouble())/7.0;
				break;
		}
		
		switch (actMinAsPercent) {
			case 1:
				Helper.drawColorCircle(dc, actMinX, actMinY, actMinRad, Ui.loadResource(Rez.Drawables.MinutesIcon), ((actMin/actMinGoal)*100).toNumber().toString() + "%", actMinFont, actMinColor);
				break;
			case 0:
			default:
				Helper.drawColorCircle(dc, actMinX, actMinY, actMinRad, Ui.loadResource(Rez.Drawables.MinutesIcon), actMin.toNumber().toString(), actMinFont, actMinColor);
				break;
		}		
	}
}