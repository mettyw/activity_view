using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsBase extends ViewBase {

    var colorBar = Gfx.COLOR_BLUE;
    var colorBarShadow = Gfx.COLOR_DK_BLUE;
    var title = "Title";
    var unit = "unit";

    function initialize(aDelegate, aColorScheme) {
        ViewBase.initialize(aDelegate, aColorScheme);
    }

    // Update the view
    function onUpdate(dc) {
        if ( ViewBase.checkHasData(dc) == false ) {
            return;
        }

        var history = ActivityMonitor.getHistory();
        var data = new [8];
        data[0] = [getItemValue(ActivityMonitor.getInfo()), getDayText(Time.now())];
        data[1] = [getItemValue(history[6]), getDayText(history[6].startOfDay)];
        for (var i = 1; i < history.size() && i <= 6; i++) {
            var item = history[history.size() - 1 - i];
            data[i+1] = [getItemValue(item), getDayText(item.startOfDay)];
        }

        var uiHelper = new UiHelperDetailView(colorScheme);
        uiHelper.initColors(colorBar, colorBarShadow);
        uiHelper.initLayout(dc);
        uiHelper.initData(title, unit, data);
        uiHelper.draw();
    }

    // utility functions

    function getItemValue(item) {
        return "n/a";
    }

}


