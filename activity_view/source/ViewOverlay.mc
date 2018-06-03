using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewOverlay extends ViewBase {

    function initialize(aColorScheme) {
        ViewBase.initialize(aColorScheme);
    }

    // Update the view
    function onUpdate(dc) {
        if ( ViewBase.checkHasData(dc) == false ) {
            return;
        }

        var history = ActivityMonitor.getHistory();
        var data = new [8];

        var info = ActivityMonitor.getInfo();
        data[0] = [info.calories, info.steps, info.distance, getDayText(Time.now())];
        data[1] = getItemValues(history[6]);
        for (var i = 1; i < history.size() && i <= 6; i++) {
            var item = history[history.size() - 1 - i];
            data[i+1] = getItemValues(item);
        }

        var uiHelper = new UiHelperOverlayView(colorScheme);
        uiHelper.initLayout(dc);
        uiHelper.initData("Graph", data);
        uiHelper.draw();
    }

    function getItemValues(item) {
        return [item.calories, item.steps, item.distance, getDayText(item.startOfDay)];
    }

}


