using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsSteps extends ViewDetailsBase {

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

}
