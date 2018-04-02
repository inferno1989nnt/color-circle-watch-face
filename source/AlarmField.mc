/** This class displays the number of alarms set on the user's watch.  The following are the options from the parameter list:

	-	location on user screen (actMinX and actMinY) INTEGER
	-	color of the active minutes (actMinColor), a Gfx. constant or custom color from resources COLOR
	-	font of the active minutes (actMinFont), a Gfx. constant or custom font from resources FONT
*/

using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class AlarmField extends Ui.Drawable {

	var alm;
	var almX;
	var almY;
	var almRad;
	var almColor;
	var almFont;
	
	function initialize(palmX, palmY, palmRad, palmFont, palmColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		alm = 0;
		almX = palmX;
		almY = palmY;
		almRad = palmRad;
		almColor = palmColor;
		almFont = palmFont;
	}
	
	function draw(dc) {
		alm = System.getDeviceSettings().alarmCount;
		Helper.drawColorCircle(dc, almX, almY, almRad, Ui.loadResource(Rez.Drawables.AlarmIcon), alm.toString(), almFont, almColor);
	}
}