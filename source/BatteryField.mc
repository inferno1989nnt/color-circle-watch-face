/** This class will display the user's watch's remaining battery life.  The parameter list includes options for
	-	X and Y locations of type INTEGER
	-	display font of type FONT
	-	display color of type COLOR
	The battery life is displayed in the following colors, with a "%" appended:
	-	RED when < 10
	-	YELLOW when > 10 and < 20
	-	parameter color when >20
*/


using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class BatteryField extends Ui.Drawable {

	var batLife;
	var batX;
	var batY;
	var batRad;
	var batFont;
	var batColor;

	function initialize(pbatX, pbatY, pbatRad, pbatFont, pbatColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		batLife = 0;
		batX = pbatX;
		batY = pbatY;
		batRad = pbatRad;
		batFont = pbatFont;
		batColor = pbatColor;
	}
	
	function draw(dc) {
		batLife = System.getSystemStats().battery;
		if (batLife > 20) {
			// Keep color
		} else if (batLife > 10) {
			batColor = Gfx.COLOR_YELLOW;
		} else {
			batColor = Gfx.COLOR_RED;
		}
		Helper.drawColorCircle(dc, batX, batY, batRad, Ui.loadResource(Rez.Drawables.BatteryIcon), batLife.toNumber().toString() + "%", batFont, batColor);
	}
}