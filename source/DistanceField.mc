/**	This class will calcuate and display the distance moved for the day.  The parameter list includes the options:
	-	X and Y location on the screen of type INTEGER
	-	display color of type COLOR
	-	display font of type FONT
	The distance will be in miles or kilometers(and appended with "m" or "k"), based upon the user's watch settings.  
*/


using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class DistanceField extends Ui.Drawable {

	var dist;
	var distX;
	var distY;
	var distRad;
	var distColor;
	var distFont;

	function initialize(pdistX, pdistY, pdistRad, pdistFont, pdistColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		dist = 0;
		distX = pdistX;
		distY = pdistY;
		distRad = pdistRad;
		distColor = pdistColor;
		distFont = pdistFont;
	}
	
	function draw(dc) {
		var strDist = "";
		dist = ActMon.getInfo().distance;
		if(dist != null) {
			if (System.getDeviceSettings().distanceUnits == 0) {
				dist = dist.toFloat()/100000.0;
				strDist = dist.format("%.1f").toString() + "k";
			} else {
				dist = dist.toFloat()*.000006213712;
				strDist = dist.format("%.1f").toString() + "m";
			}
		} else {
			strDist = "--";
		}
		Helper.drawColorCircle(dc, distX, distY, distRad, Ui.loadResource(Rez.Drawables.DistanceIcon), strDist, distFont, distColor);
	}
}
			