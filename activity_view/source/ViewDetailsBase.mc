using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewDetailsBase extends Ui.View {

    var delegate;

    var colorBar = Gfx.COLOR_BLUE;
    var colorBarShadow = Gfx.COLOR_DK_BLUE;
    var title = "Title";
    var unit = "unit";

    function initialize(aDelegate) {
        View.initialize();
        delegate = aDelegate;
    }

    function onHide() {
        delegate.persistState();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        if (ActivityMonitor.getHistory().size() == 0) {
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.drawText(109, 109, Graphics.FONT_TINY, "NO DATA",
            Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
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

        var uiHelper = new UiHelperDetailView();
        uiHelper.initColors(colorBar, colorBarShadow);
        uiHelper.initLayout(dc);
        uiHelper.initData(title, unit, data);
        uiHelper.draw();
    }

    // utility functions

    function getItemValue(item) {
        return "n/a";
    }

    function getDayText(moment) {
        return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
    }

}


