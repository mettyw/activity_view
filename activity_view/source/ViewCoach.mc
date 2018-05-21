using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ViewCoach extends ViewBase {

    var text = "n/a";

    function initialize(aDelegate, aColorScheme) {
        ViewBase.initialize(aDelegate, aColorScheme);
        var coach = new Coach();
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


