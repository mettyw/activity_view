using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewBase extends Ui.View {

    var delegate;
    var colorScheme;

    function initialize(aDelegate, aColorScheme) {
        View.initialize();
        delegate = aDelegate;
        colorScheme = aColorScheme;
    }

    function onHide() {
        delegate.persistState();
    }

    function checkHasData(dc) {
        if (ActivityMonitor.getHistory().size() == 0) {
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.drawText(109, 109, Graphics.FONT_TINY, "NO DATA TO DISPLAY",
            Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            return false;
        } else {
            return true;
        }
    }

    function getDayText(moment) {
        return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
    }


}


