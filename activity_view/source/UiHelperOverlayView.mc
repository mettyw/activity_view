using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class UiHelperOverlayView extends UiHelperBase {

    //data
    var title;
    var unit1;
    var unit2;
    var unit3;
    var data;

    // layouting
    var x;
    var y;
    var xd;
    var yd;
    var xs;
    var ys;
    var margin;

    function initialize() {
        UiHelperBase.initialize();
    }

    function initColors() {
        UiHelperBase.initColors();
    }

    function initLayout(dc) {
        UiHelperBase.initLayout(dc);
        maxWidth = width - 20*2 - 30;

        x = 10;
        y = 30;
        yd = 20;
        margin = 10;
        xs = 2+margin;
        ys = 30;
        // calculate cell size for 8 columns, considering the width and margins
        xd = (width - (15+xs)) / 8;
    }

    function initData(aTitle, aData) {
        title = aTitle;
        unit1 = "kCal";
        unit2 = "steps";
        unit3 = "m";
        data = aData;
    }

    public function draw() {
        self.drawUi();
    }

    public function drawUi() {
        dc.setColor(colorFg, colorBg);
        dc.clear();

       // dc.setColor(colorBar, Gfx.COLOR_TRANSPARENT);
       // dc.fillRectangle(0, 0, width, 23);

        dc.setColor(colorFg, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 1, Gfx.FONT_SMALL, title, Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(colorLine, Gfx.COLOR_TRANSPARENT);
        // horizontal lines
        //dc.drawLine(x, 23, width-x, 23);
        //dc.drawLine(x, y+yd*1, width-x, y+yd*1);
        dc.drawLine(x, y, width-x, y);
        //dc.drawLine(x, y+yd*4, width-x, y+yd*4);

        dc.drawLine(x, y+yd*5, width-x, y+yd*5);
        //dc.drawLine(x, 160, width-x, 160);

        // vertical lines
        //dc.drawLine(10+32, y+yd*1, 10+32, y+yd*5);

        for (var i = 0; i < data.size(); i++) {
            var entry = data[i];
            dc.setColor(colorFg, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xs+2+xd*i, y + yd*5, Gfx.FONT_SYSTEM_XTINY, entry[3], Gfx.TEXT_JUSTIFY_LEFT);

            dc.setColor(colorLine, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*i, y, xs+2+xd*i, y+yd*5);

            // draw shadow
            // TODO
            dc.setColor(colorCalShadow, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1+1, y+4-1, xd-8, 100);

            // draw bar
            dc.setColor(colorCal, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1, y+4, xd-8, 100);

        }

    }

    function drawCellValue(col, row, value) {
        var dispValue = UiHelperBase.getDisplayValue(value);
        dc.drawText(xs+xd*col, ys+yd*row, Gfx.FONT_SMALL, dispValue, Gfx.TEXT_JUSTIFY_RIGHT);
    }

}


