using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsSteps extends ViewDetailsBase {

    function initialize(aColorScheme) {
        ViewDetailsBase.initialize(aColorScheme);

        colorBar = aColorScheme.colorStep;
        colorBarShadow = aColorScheme.colorStepShadow;
        title = "Steps";
        unit = "steps";
    }

    function getItemValue(item) {
        return item.steps;
    }

}
