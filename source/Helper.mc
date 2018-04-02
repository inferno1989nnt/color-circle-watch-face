using Toybox.Graphics as Gfx;

module Helper {

	var MARGIN = 1;
	var PEN_WIDTH = 3;
	
	function drawColorCircle(dc, circleXloc, circleYloc, circleRad, drawable, data, font, color) {
	
		// Set pen width
		dc.setPenWidth(PEN_WIDTH);
		// Set color for pen
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
		// Draw color circle
		dc.drawCircle(circleXloc, circleYloc, circleRad);
		
		// Check if circle may contain both of symbol and text
		var canDrawSymbol = canDrawSymbol(dc, circleRad, drawable, font);
		
		// Draw the data symbol and data text value
		if (canDrawSymbol) {
			dc.drawBitmap(circleXloc - drawable.getWidth() / 2 + PEN_WIDTH / 2, circleYloc - (circleRad + drawable.getHeight()) / 2, drawable);
			dc.drawText(circleXloc + PEN_WIDTH / 2, circleYloc, font, data, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.drawText(circleXloc + PEN_WIDTH / 2, circleYloc - dc.getFontHeight(font) / 2 + PEN_WIDTH / 2, font, data, Gfx.TEXT_JUSTIFY_CENTER);
		}
		
	}
	
	function canDrawSymbol(dc, circleRad, drawable, textFont) {
		return ( 2 * ( circleRad - PEN_WIDTH / 2 ) ) > ( dc.getFontHeight(textFont) + drawable.getHeight() + 4 * MARGIN);
	}
}
