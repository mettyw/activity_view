using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsCalories extends ViewDetailsBase {

    function initialize(aDelegate) {
        ViewDetailsBase.initialize(aDelegate);

        colorBar = Gfx.COLOR_BLUE;
        colorBarShadow = Gfx.COLOR_DK_BLUE;
        title = "Calories";
        unit = "kCal";
    }

    function getItemValue(item) {
        return item.calories;
    }


}


