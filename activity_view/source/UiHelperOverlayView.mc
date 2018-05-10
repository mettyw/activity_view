using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class UiHelperOverlayView extends UiHelperBase {

    //data
    var title;
    var unit1;
    var unit2;
    var unit3;
    var data;

    var valueMaxCal = 0;
    var valueMaxStep = 0;
    var valueMaxDist = 0;

    // layouting
    var x;
    var y;
    var xd;
    var fontHeight;
    var xs;
    var ys;
    var margin;
    var barMaxHeight;

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
        y = 22;
        //yd = 20;
        margin = 10;
        xs = 2+margin;
        ys = 30;
        // calculate cell size for 8 columns, considering the width and margins
        xd = (width - (15+xs)) / 8;
        fontHeight = dc.getFontHeight(Gfx.FONT_SMALL);
        barMaxHeight = 110;
        System.println(dc.getFontHeight(Gfx.FONT_SMALL));
        System.println(dc.getFontHeight(Gfx.FONT_TINY));
        System.println(dc.getFontHeight(Gfx.FONT_XTINY));
    }

    function initData(aTitle, aData) {
        title = aTitle;
        unit1 = "kCal";
        unit2 = "steps";
        unit3 = "m";
        data = aData;

        for (var i = 0; i < data.size(); i++) {
            //var entry = data[i];
            if ( data[i][0] > valueMaxCal ) {
                valueMaxCal = data[i][0];
            }
            if ( data[i][1] > valueMaxStep ) {
                valueMaxStep = data[i][1];
            }
            if ( data[i][2] > valueMaxDist ) {
                valueMaxDist = data[i][2];
            }
        }
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
        dc.drawLine(x, y, width-x, y);
        dc.drawLine(x, y+barMaxHeight, width-x, y+barMaxHeight);
        dc.drawLine(x, y+barMaxHeight+fontHeight, width-x, y+barMaxHeight+fontHeight);

        for (var i = 0; i < data.size(); i++) {
            var valueCal = data[i][0];
            var valueDay = data[i][3];
            dc.setColor(colorFg, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xs+2+xd*i, y + barMaxHeight, Gfx.FONT_SYSTEM_XTINY, valueDay, Gfx.TEXT_JUSTIFY_LEFT);

            var barHeight = barMaxHeight * (valueCal / valueMaxCal.toFloat());

            // draw shadow
            // TODO
            dc.setColor(colorCalShadow, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1+1, y+1-1 + (barMaxHeight - barHeight), xd-8, barHeight);

            // draw bar
            dc.setColor(colorCal, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1, y+1 + (barMaxHeight - barHeight), xd-8, barHeight);
        }

        for (var i = 0; i < data.size() - 1; i++) {
            var valueStep1 = data[i][1];
            var valueDist1 = data[i][2];
            var valueStep2 = data[i+1][1];
            var valueDist2 = data[i+1][2];

            var yDist1 = barMaxHeight * (valueDist1 / valueMaxDist.toFloat());
            var yDist2 = barMaxHeight * (valueDist2 / valueMaxDist.toFloat());

            dc.setColor(colorDistShadow, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), y+1 + (barMaxHeight - yDist1)+1, xs+2+xd*(i+0.5+1), y+1 + (barMaxHeight - yDist2)+1);

            dc.setColor(colorDist, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), y+1 + (barMaxHeight - yDist1), xs+2+xd*(i+0.5+1), y+1 + (barMaxHeight - yDist2));

            var yStep1 = barMaxHeight * (valueStep1 / valueMaxStep.toFloat());
            var yStep2 = barMaxHeight * (valueStep2 / valueMaxStep.toFloat());

            dc.setColor(colorStepShadow, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), y+1 + (barMaxHeight - yStep1)+1, xs+2+xd*(i+0.5+1), y+1 + (barMaxHeight - yStep2)+1);

            dc.setColor(colorStep, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), y+1 + (barMaxHeight - yStep1), xs+2+xd*(i+0.5+1), y+1 + (barMaxHeight - yStep2));

        }

    }

}


