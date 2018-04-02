/** This class gets and displays the user's daily step count.  The parameter list includes options for:
	-	X and Y display location of type INTEGER
	-	display color of type COLOR
	-	display font of type FONT
	
	The steps can be displayed as steps or as a percent of step goal.	
*/

using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as ActMon;

class StepsField extends Ui.Drawable {

	var steps = null;
	var stepPercent = null;
	var stepFont = null;
	var stepColor = null;
	var stepX = null;
	var stepY = null;
	var stepRad = null;

	function initialize(pstepX, pstepY, pstepRad, pfont, pcolor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		steps = 0;
		stepPercent = 0;
		stepFont = pfont;
		stepColor = pcolor;
		stepX = pstepX;
		stepY = pstepY;
		stepRad = pstepRad;
	}
	
	function draw(dc) {
		steps = ActMon.getInfo().steps;
		Helper.drawColorCircle(dc, stepX, stepY, stepRad, Ui.loadResource(Rez.Drawables.StepsIcon), steps, stepFont, stepColor);
	}
	
	function drawPercent(dc) {
		var strStepPercent = "";
		if (ActMon.getInfo().stepGoal > 0) {
			stepPercent = ((ActMon.getInfo().steps.toDouble()/ActMon.getInfo().stepGoal.toDouble())*100).toNumber();
			strStepPercent = stepPercent.toString() + "%";
		} else {
			strStepPercent = "--%";
		}
		Helper.drawColorCircle(dc, stepX, stepY, stepRad, Ui.loadResource(Rez.Drawables.StepsIcon), strStepPercent, stepFont, stepColor);
	}

}