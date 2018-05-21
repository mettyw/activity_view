using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class UiHelperCoachView extends UiHelperBase {

    //data
    var title;
    var text;

    // layouting
    var x;
    var y;
    var xd;
    var fontHeight;
    var xs;
    var ys;
    var margin;
    var barMaxHeight;

    var font = Gfx.FONT_SMALL;

    function initialize(aColorScheme) {
        UiHelperBase.initialize(aColorScheme);
    }

    function initLayout(dc) {
        UiHelperBase.initLayout(dc);
        maxWidth = width - 30*2;

        x = 6;
        y = 22;
        //yd = 20;
        margin = 10;
        xs = x+margin;
        ys = y+3;
        // calculate cell size for 8 columns, considering the width and margins
        xd = (width - (15+xs)) / 8;
        fontHeight = dc.getFontHeight(Gfx.FONT_SMALL);
        barMaxHeight = 110 -(2*2);
    }

    function initData(aTitle, aText) {
        title = aTitle;
        text = aText;
    }

    public function draw() {
        dc.setColor(colors.colorFg, colors.colorBg);
        dc.clear();

        dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 1, Gfx.FONT_SMALL, title, Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(colors.colorLine, Gfx.COLOR_TRANSPARENT);

        // horizontal lines
        dc.drawLine(xs, y, width-xs, y);
        dc.drawLine(xs, y+barMaxHeight+4+fontHeight, width-xs, y+barMaxHeight+4+fontHeight);

        var newText = formatText(text);

        dc.setColor(colors.colorFg, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (y+barMaxHeight+4+fontHeight)/2, Gfx.FONT_SMALL, newText, Gfx.TEXT_JUSTIFY_CENTER + Gfx.TEXT_JUSTIFY_VCENTER);

    }

    private function formatText(text) {
        if ( dc.getTextWidthInPixels(text, font) < maxWidth ) {
            return text + "\n";
        } else {
            var result = "";
            var line;
            var remainder = text;
            do {
                var t = calculateLine("", remainder);
                result = result + "\n" + t[0];
                remainder = t[1];
            } while ( remainder.length() > 0 );
            return result;
        }
    }

    private function calculateLine(line, remainder) {
        var s = splitstr(remainder);
        var word = s[0];
        remainder = s[1];
        if ( remainder.length() == 0  ) {
            return [line + word + " ", ""];
        }
        else if ( dc.getTextWidthInPixels(line + word + " ", font) > maxWidth ) {
            return [line, word + " " + remainder];
        }
        else {
            return calculateLine(line + word + " ", remainder);
        }
    }

    private function splitstr(str) {
        var idx = str.find(" ");
        if ( idx == null ) {
            return [str, ""];
        }
        var s1 = str.substring(0, idx);
        var s2 = str.substring(idx+1, str.length());
        return [s1, s2];
    }
}


