using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewSummary extends Ui.View {

    var delegate;

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

        var info = ActivityMonitor.getInfo();

        var stepNow = info.steps;
        var calNow = info.calories;
        var distNow = info.distance/100.0; // convert cm to m

        var history = ActivityMonitor.getHistory();

        var stepMax = 0;
        var stepSum = 0;
        var distMax = 0;
        var distSum = 0;
        var calMax = 0;
        var calSum = 0;

        for (var i = 0; i < history.size(); i++) {
            var item = history[i];
            stepSum += item.steps;
            distSum += item.distance/100.0; // convert cm to m;
            calSum += item.calories;
            if ( stepMax < item.steps ) {
                stepMax = item.steps;
            }
            if ( distMax < item.distance ) {
                distMax = item.distance/100.0; // convert cm to m;
            }
            if ( calMax < item.calories ) {
                calMax = item.calories;
            }
        }

        var stepAvg = stepSum / history.size();
        var distAvg = distSum / history.size();
        var calAvg = calSum / history.size();

        var data = [stepNow, calNow, distNow, stepMax, stepSum, distMax, distSum, calMax, calSum, stepAvg, distAvg, calAvg];

        var uiHelper = new UiHelperSummaryView();
        uiHelper.initColors();
        uiHelper.initLayout(dc);
        uiHelper.initData("Summary", data);
        uiHelper.draw();
    }

}


