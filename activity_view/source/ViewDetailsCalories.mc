using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsCalories extends ViewDetailsBase {

    function initialize(aDelegate, aColorScheme) {
        ViewDetailsBase.initialize(aDelegate, aColorScheme);

        colorBar = aColorScheme.colorCal;
        colorBarShadow = aColorScheme.colorCalShadow;
        title = "Calories";
        unit = "kCal";
    }

    function getItemValue(item) {
        return item.calories;
    }


}


