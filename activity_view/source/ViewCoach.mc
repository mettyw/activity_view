using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewCoach extends ViewBase {

    var text = "n/a";

    function initialize(aDelegate, aColorScheme) {
        ViewBase.initialize(aDelegate, aColorScheme);

        var info = ActivityMonitor.getInfo();
        var vhour = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG).hour.toFloat() + (Time.Gregorian.info(Time.now(), Time.FORMAT_LONG).min.toFloat() / 60);
        var today = [info.calories, info.steps, info.stepGoal, info.distance, vhour];

        var history = ActivityMonitor.getHistory();
        var data = new [7];
        for (var i = 0; i < history.size() && i <= 6; i++) {
            var item = history[i];
            data[i] = [item.calories, item.steps, item.stepGoal, item.distance/(100.0*1000), 24];
        }

        var coach = new Coach(today, data);
        text = coach.getText();
    }

    // Update the view
    function onUpdate(dc) {
        if ( ViewBase.checkHasData(dc) == false ) {
            return;
        }

        var uiHelper = new UiHelperCoachView(colorScheme);
        uiHelper.initLayout(dc);
        uiHelper.initData("Coach", text);
        uiHelper.draw();
    }

    function triggerAction() {
        Ui.requestUpdate();
    }

}


