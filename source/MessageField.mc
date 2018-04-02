/**This class gets and displays the user's message notifications.  The parameter list includes the following options:
-	X and Y display location of type INTEGER
-	display color of type COLOR
-	display font of type FONT
*/
using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Graphics as Gfx;

class MessageField extends Ui.Drawable {

	var messages;
	var messagesX;
	var messagesY;
	var messagesRad;
	var messagesColor;
	var messagesFont;

	function initialize(pmessagesX, pmessagesY, pmessagesRad, pmessagesFont, pmessagesColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		messages = 0;
		messagesX = pmessagesX;
		messagesY = pmessagesY;
		messagesRad = pmessagesRad;
		messagesColor = pmessagesColor;
		messagesFont = pmessagesFont;
	}
	
	function draw(dc) {
		messages = System.getDeviceSettings().notificationCount;
		Helper.drawColorCircle(dc, messagesX, messagesY, messagesRad, Ui.loadResource(Rez.Drawables.MessageIcon), messages.toString(), messagesFont, messagesColor);
	}
}