using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsDistance extends ViewDetailsBase {

    function initialize(aDelegate, aColorScheme) {
        ViewDetailsBase.initialize(aDelegate, aColorScheme);

        colorBar = aColorScheme.colorDist;
        colorBarShadow = aColorScheme.colorDistShadow;
        title = "Distance";
        unit = "km";
    }

    function getItemValue(item) {
        // convert from cm to m
        return item.distance/(100.0*1000);
    }

}


