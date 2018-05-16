using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class UiHelperDetailView extends UiHelperBase {

    // data
    var title;
    var unit;
    var data;

    var valueMax = 0;
    var valueTot = 0;
    var valueAvg = 0;

    // color scheme
    var colorBar;
    var colorShadow;

    // layouting
    var x;
    var y;
    var xs;
    var yd;
    var yb;

    function initialize(aColorScheme) {
        UiHelperBase.initialize(aColorScheme);
    }


    function initColors(aColorBar, aColorShadow) {
        colorBar = aColorBar;
        colorShadow = aColorShadow;
    }

    function initLayout(dc) {
        UiHelperBase.initLayout(dc);

        x = 20;
        y = 22;
        yd = 17;
        xs = 46;
        yb = 161; // bottom y

        maxWidth = width - xs - 20;
    }

    function initData(aTitle, aUnit, aData) {
        title = aTitle;
        unit = aUnit;
        data = aData;

        for (var i = 0; i < data.size(); i++) {
            if ( data[i][0] > valueMax ) {
                valueMax = data[i][0];
            }
            // skip item 0 for statistics because this is the current value
            if ( i != 0 ) {
                valueTot = valueTot + data[i][0];
            }
        }
        // skip item 1 for statistics because this is the current value
        valueAvg = valueTot/(data.size() - 1);

    }

    public function draw() {
        self.drawUi();
        self.drawTitle();
        self.drawAverage();

        for (var i = 0; i < data.size(); i++) {
            var entry = data[i];
            self.drawDataRow(i, entry[1], entry[0]);
        }
    }

    public function drawUi() {
        dc.setColor(colors.colorFg, colors.colorBg);
        dc.clear();

//        dc.setColor(colorBar, Gfx.COLOR_TRANSPARENT);
//        dc.fillRectangle(0, 0, width, 23);


        dc.setColor(colors.colorLine, Gfx.COLOR_TRANSPARENT);
        // horizontal lines
        dc.drawLine(x, y, width-x, y);
        dc.drawLine(x, y+yd+1, width-x, y+yd+1);
        dc.drawLine(x, yb, width-x, yb);

        // vertical lines
        dc.drawLine(xs-5, y, xs-5, yb);
    }

    public function drawTitle() {
        dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(width / 2, 1, Gfx.FONT_SMALL, title, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 1, Gfx.FONT_SMALL, title + " (" + getDisplayValue(valueTot) + " " + unit + ")", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(colorFg2, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(width / 2, yb, Gfx.FONT_SMALL, "Sum: " + getDisplayValue(valueTot) + " " + unit, Gfx.TEXT_JUSTIFY_CENTER);
    }

    public function drawAverage() {
        var value = maxWidth * (valueAvg.toDouble() / valueMax.toDouble());
        /*
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(xs + maxWidth*0.1, 23, xs + maxWidth*0.1, yb);
        dc.drawLine(xs + maxWidth*0.2, 23, xs + maxWidth*0.2, yb);
        dc.drawLine(xs + maxWidth*0.3, 23, xs + maxWidth*0.3, yb);
        dc.drawLine(xs + maxWidth*0.4, 23, xs + maxWidth*0.4, yb);
        dc.drawLine(xs + maxWidth*0.5, 23, xs + maxWidth*0.5, yb);
        dc.drawLine(xs + maxWidth*0.6, 23, xs + maxWidth*0.6, yb);
        dc.drawLine(xs + maxWidth*0.7, 23, xs + maxWidth*0.7, yb);
        dc.drawLine(xs + maxWidth*0.8, 23, xs + maxWidth*0.8, yb);
        dc.drawLine(xs + maxWidth*0.9, 23, xs + maxWidth*0.9, yb);
        dc.drawLine(xs + maxWidth*1.0, 23, xs + maxWidth*1.0, yb);
        */

        dc.setColor(colors.colorAvg, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(xs + value, y, xs + value, yb);

        var text = getDisplayValue(valueAvg);

        var textWidth = dc.getTextWidthInPixels(text, Gfx.FONT_SMALL);

        var xp = xs + value - textWidth/2;
        if ( (xs + value + textWidth/2) < (dc.getWidth()-40) ) {
            xp = xs + value;
        }
        if ( ((xs + value - textWidth/2) < 40) ) {
            xp = xs + value + textWidth/2;
        }

        dc.drawText(xp, yb, Gfx.FONT_SMALL, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

    public function drawDataRow(index, day, value) {
        var valueWidth = maxWidth * (value.toDouble() / valueMax.toDouble());
        var valueText = UiHelperBase.getDisplayValue(value);

        if ( index == 0 ) {
            dc.setColor(colors.colorNow, Gfx.COLOR_TRANSPARENT);
        } else {
            dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
        }
        dc.drawText(x, y+yd*index, Gfx.FONT_SMALL, day, Gfx.TEXT_JUSTIFY_LEFT);

        // draw shadow
        dc.setColor(colorShadow, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(xs+1, y+4 + yd*index+1, valueWidth, yd-4);

        // draw bar
        dc.setColor(colorBar, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(xs, y+4 + yd*index, valueWidth, yd-4);

        if ( dc.getTextWidthInPixels(valueText, Gfx.FONT_SYSTEM_XTINY)+2 < valueWidth ) {
            dc.setColor(colors.colorBg, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xs+valueWidth-2, y + yd*index, Gfx.FONT_SYSTEM_XTINY, valueText, Gfx.TEXT_JUSTIFY_RIGHT);
        } else {
            dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xs+valueWidth+2, y + yd*index, Gfx.FONT_SYSTEM_XTINY, valueText, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

}


