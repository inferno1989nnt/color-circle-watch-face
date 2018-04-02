/**	This class displays the user's current altitude.  The parameter list includes:
	-	X and Y location INTEGER
	-	display color, of type COLOR
	-	display font, of type FONT
	
	The altitude will be displayed in meters or feet (with "m" or "ft" label) depending on user's watch settings.
*/	


using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class AltitudeField extends Ui.Drawable {

	var alt;
	var altX;
	var altY;
	var altRad;
	var altColor;
	var altFont;

	function initialize(paltX, paltY, paltRad, paltFont, paltColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		alt = 0;
		altX = paltX;
		altY = paltY;
		altRad = paltRad;
		altColor = paltColor;
		altFont = paltFont;
	}
	
	function draw(dc) {
		var strAlt = "";
		alt = Activity.getActivityInfo().altitude;
		dc.setColor(altColor, Gfx.COLOR_TRANSPARENT);
		if (alt != null) {
			if (System.getDeviceSettings().elevationUnits == 1) {
				alt = alt * 3.28;
				strAlt = alt.toNumber().toString() + "ft";
			} else {
				strAlt = alt.toNumber().toString() + "m";
			}
		} else {
			strAlt = "--";
		}
		Helper.drawColorCircle(dc, altX, altY, altRad, Ui.loadResource(Rez.Drawables.ElevationIcon), strAlt, altFont, altColor);
	}
}
