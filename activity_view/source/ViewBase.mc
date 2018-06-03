using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewBase extends Ui.View {

    var colorScheme;

    function initialize(aColorScheme) {
        View.initialize();
        colorScheme = aColorScheme;
    }

    function onHide() {
        colorScheme = null;
    }

    function checkHasData(dc) {
        if (ActivityMonitor.getHistory().size() == 0) {
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.drawText(109, 109, Gfx.FONT_TINY, "Not enough activity data yet.", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
            return false;
        } else {
            return true;
        }
    }

    function getDayText(moment) {
        return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
    }


}


