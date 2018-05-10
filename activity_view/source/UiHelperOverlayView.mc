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
    var valueAvgCal;
    var valueAvgStep;
    var valueAvgDist;

    // layouting
    var x;
    var y;
    var xd;
    var fontHeight;
    var xs;
    var ys;
    var margin;
    var barMaxHeight;

    function initialize(aColorScheme) {
        UiHelperBase.initialize(aColorScheme);
    }

    function initLayout(dc) {
        UiHelperBase.initLayout(dc);
        maxWidth = width - 20*2 - 30;

        x = 10;
        y = 22;
        //yd = 20;
        margin = 10;
        xs = 2+margin;
        ys = y+3;
        // calculate cell size for 8 columns, considering the width and margins
        xd = (width - (15+xs)) / 8;
        fontHeight = dc.getFontHeight(Gfx.FONT_SMALL);
        barMaxHeight = 110 -(2*2);
    }

    function initData(aTitle, aData) {
        title = aTitle;
        unit1 = "kCal";
        unit2 = "steps";
        unit3 = "m";
        data = aData;

        var calSum = 0;
        var stepSum = 0;
        var distSum = 0;
        for (var i = 0; i < data.size(); i++) {
            if ( i > 0 ) {
                calSum += data[i][0];
                stepSum += data[i][1];
                distSum += data[i][2]/100.0; // convert cm to m;
            }
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
        valueAvgCal = calSum / data.size()-1;
        valueAvgStep = stepSum / data.size()-1;
        valueAvgDist = distSum / data.size()-1;
    }

    public function draw() {
        self.drawUi();
    }

    public function drawUi() {
        dc.setColor(colors.colorFg, colors.colorBg);
        dc.clear();

       // dc.setColor(colorBar, Gfx.COLOR_TRANSPARENT);
       // dc.fillRectangle(0, 0, width, 23);

        dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 1, Gfx.FONT_SMALL, title, Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(colors.colorLine, Gfx.COLOR_TRANSPARENT);

        // horizontal lines
        dc.drawLine(x, y, width-x, y);
        dc.drawLine(x, y+barMaxHeight+4, width-x, y+barMaxHeight+4);
        dc.drawLine(x, y+barMaxHeight+4+fontHeight, width-x, y+barMaxHeight+4+fontHeight);

        for (var i = 0; i < data.size(); i++) {
            var valueCal = data[i][0];
            var valueDay = data[i][3];
            if ( i == 0 ) {
                dc.setColor(colors.colorNow, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
            }
            dc.drawText(xs+2+xd*i, y + barMaxHeight+3, Gfx.FONT_SYSTEM_XTINY, valueDay, Gfx.TEXT_JUSTIFY_LEFT);

            var barHeight = barMaxHeight * (valueCal / valueMaxCal.toFloat());
            var avgLineY = barMaxHeight * (valueAvgCal / valueMaxCal.toFloat());

            // draw avg line
            //dc.setColor(colorCalShadow, Gfx.COLOR_TRANSPARENT);
            //dc.drawLine(x, y+1+(barMaxHeight-avgLineY), width-x, y+1+(barMaxHeight-avgLineY));

            // draw shadow
            dc.setColor(colors.colorCalShadow, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1+1, ys-1 + (barMaxHeight - barHeight), xd-8, barHeight);

            // draw bar
            dc.setColor(colors.colorCal, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xs+2+xd*i+1, ys + (barMaxHeight - barHeight), xd-8, barHeight);
        }

        for (var i = 0; i < data.size() - 1; i++) {
            var valueStep1 = data[i][1];
            var valueDist1 = data[i][2];
            var valueStep2 = data[i+1][1];
            var valueDist2 = data[i+1][2];

            var yDist1 = barMaxHeight * (valueDist1 / valueMaxDist.toFloat());
            var yDist2 = barMaxHeight * (valueDist2 / valueMaxDist.toFloat());

            dc.setColor(colors.colorDistShadow, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), ys + (barMaxHeight - yDist1)+1, xs+2+xd*(i+0.5+1), ys + (barMaxHeight - yDist2)+1);

            dc.setColor(colors.colorDist, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), ys + (barMaxHeight - yDist1), xs+2+xd*(i+0.5+1), ys + (barMaxHeight - yDist2));

            var yStep1 = barMaxHeight * (valueStep1 / valueMaxStep.toFloat());
            var yStep2 = barMaxHeight * (valueStep2 / valueMaxStep.toFloat());

            dc.setColor(colors.colorStepShadow, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), ys + (barMaxHeight - yStep1)+1, xs+2+xd*(i+0.5+1), ys + (barMaxHeight - yStep2)+1);

            dc.setColor(colors.colorStep, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(xs+2+xd*(i+0.5), ys + (barMaxHeight - yStep1), xs+2+xd*(i+0.5+1), ys + (barMaxHeight - yStep2));

        }

    }

}


