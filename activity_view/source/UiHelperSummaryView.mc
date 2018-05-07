using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class UiHelperSummaryView extends UiHelperBase {

    //data
    var title;
    var stepNow;
    var calNow;
    var distNow;
    var stepMax = 0;
    var stepSum = 0;
    var distMax = 0;
    var distSum = 0;
    var calMax = 0;
    var calSum = 0;
    var stepAvg;
    var distAvg;
    var calAvg;

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
        xs = 32+margin;
        ys = 30;
        // calculate cell size for 3 columns, considering the width and margins
        xd = (width - (15+xs)) / 3;
    }

    function initData(aTitle, data) {
        title = aTitle;
        stepNow = data[0];
        calNow = data[1];
        distNow = data[2];
        stepMax = data[3];
        stepSum = data[4];
        distMax = data[5];
        distSum = data[6];
        calMax = data[7];
        calSum = data[8];
        stepAvg = data[9];
        distAvg = data[10];
        calAvg = data[11];
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

        //dc.drawText(width / 2, 20, Gfx.FONT_XTINY, "18-04-01 - 18-04-08", textCenter);

        dc.setColor(colorLine, Gfx.COLOR_TRANSPARENT);
        // horizontal lines
        //dc.drawLine(x, 23, width-x, 23);
        dc.drawLine(x, y+yd*1, width-x, y+yd*1);
        dc.drawLine(x, y, width-x, y);
        dc.drawLine(x, y+yd*4, width-x, y+yd*4);

        dc.drawLine(x, y+yd*5, width-x, y+yd*5);
        //dc.drawLine(x, 160, width-x, 160);

        // vertical lines
        dc.drawLine(10+32, y+yd*1, 10+32, y+yd*5);

        dc.setColor(colorFg, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y+yd*1, Gfx.FONT_SMALL, "Sum", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y+yd*2, Gfx.FONT_SMALL, "Max", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y+yd*3, Gfx.FONT_SMALL, "Avg", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(colorNow, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y+yd*4, Gfx.FONT_SMALL, "Now", Gfx.TEXT_JUSTIFY_LEFT);

        drawCellValue(1, 0, "kCal");
        drawCellValue(2, 0, "steps");
        drawCellValue(3, 0, "m");

        dc.setColor(colorCal, Gfx.COLOR_TRANSPARENT);
        drawCellValue(1, 1, calSum);
        drawCellValue(1, 2, calMax);
        drawCellValue(1, 3, calAvg);
        drawCellValue(1, 4, calNow);

        dc.setColor(colorStep, Gfx.COLOR_TRANSPARENT);
        drawCellValue(2, 1, stepSum);
        drawCellValue(2, 2, stepMax);
        drawCellValue(2, 3, stepAvg);
        drawCellValue(2, 4, stepNow);

        dc.setColor(colorDist, Gfx.COLOR_TRANSPARENT);
        drawCellValue(3, 1, distSum);
        drawCellValue(3, 2, distMax);
        drawCellValue(3, 3, distAvg);
        drawCellValue(3, 4, distNow);
    }

    function drawCellValue(col, row, value) {
        var dispValue = UiHelperBase.getDisplayValue(value);
        dc.drawText(xs+xd*col, ys+yd*row, Gfx.FONT_SMALL, dispValue, Gfx.TEXT_JUSTIFY_RIGHT);
    }

}


