using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDistance extends ViewDetailsBase {

    function initialize(aDelegate) {
        ViewDetailsBase.initialize(aDelegate);

        colorBar = Gfx.COLOR_GREEN;
        colorBarShadow = Gfx.COLOR_DK_GREEN;
        title = "Distance";
        unit = "m";
    }

    function getItemValue(item) {
        // convert from cm to m
        return item.distance/(100.0);
    }

    function getDayText(moment) {
        return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
    }
}


