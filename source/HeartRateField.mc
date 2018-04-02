/** This class gets and displays the user's current heart rate.  The parameter list includes options for:
-	X and Y location of type INTEGER
-	display color of type COLOR
-	display font of type FONT

	The function first attemps to use the heart rate history, and if unavailable, used the getCurrentHeartRate command in the activity class
*/

using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class HeartRateField extends Ui.Drawable {

	var heartRateFont = null;
	var heartRateColor = null;
	var heartRateX = 0;
	var heartRateY = 0;
	var heartRateRad = 0;

	function initialize(pheartRateX, pheartRateY, pheartRateRad, pheartRateFont, pheartRateColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		heartRateFont = pheartRateFont;
		heartRateColor = pheartRateColor;
		heartRateX = pheartRateX;
		heartRateY = pheartRateY;
		heartRateRad = pheartRateRad;
	}
	
	function draw(dc) {
		var heartRate = "";

		if (ActMon has :getHeartRateHistory) {
			var HRHistory = ActMon.getHeartRateHistory(1, true);
			if ((HRHistory != null) && (HRHistory.getMax() != null) && (HRHistory.getMax() > 0) && (HRHistory.getMax() < 255)) {
				heartRate = HRHistory.getMax() + "";
			}
		} else {
			heartRate = Activity.getActivityInfo().currentHeartRate + "";
		}
		Helper.drawColorCircle(dc, heartRateX, heartRateY, heartRateRad, Ui.loadResource(Rez.Drawables.HeartRateIcon), heartRate, heartRateFont, heartRateColor);
	}
}