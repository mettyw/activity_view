using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewSteps extends ViewDetailsBase {

    function initialize(aDelegate) {
        ViewDetailsBase.initialize(aDelegate);

        colorBar = Gfx.COLOR_YELLOW;
        colorBarShadow = Gfx.COLOR_ORANGE;
        title = "Steps";
        unit = "steps";
    }

    function getItemValue(item) {
        return item.steps;
    }

    function getDayText(moment) {
        return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
    }
}
