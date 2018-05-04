using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Storage as Storage;

class ViewStateController extends Ui.InputDelegate {

    const KEY_LOADLASTVIEWSTATE = "LoadLastViewState";
    const KEY_LASTVIEWSTATE = "LastViewState";

    public var viewState = 0;

    // Constructor
    function initialize() {
        Ui.InputDelegate.initialize();
        var loadLastViewState = App.getApp().getProperty(KEY_LOADLASTVIEWSTATE);
        if ( loadLastViewState != null && loadLastViewState == true ) {
            var lastViewState = App.getApp().getProperty(KEY_LASTVIEWSTATE);
            //var lastViewState = Storage.getValue(KEY_LASTVIEWSTATE);
            if ( lastViewState != null ) {
                viewState = lastViewState;
            }
        }
    }

    function setState(newState) {
      viewState = newState;
    }

    public function persistState() {
        App.getApp().setProperty(KEY_LASTVIEWSTATE, viewState);
        //Storage.setValue(KEY_LASTVIEWSTATE, viewState);
    }

    public function getCurrentView() {
        if ( viewState == 1 ) {
          return new ViewCalories(self);
        }
        else if ( viewState == 2 ) {
          return new ViewSteps(self);
        }
        else if ( viewState == 3 ) {
          return new ViewDistance(self);
        }
        else {
          return new ViewSummary(self);
        }
    }

    function onKey(evt) {
        if (evt.getKey() == Ui.KEY_ENTER) {
            var delegate = new ViewStateController();
            viewState = (viewState + 1 ) % 4;
            delegate.setState(viewState);

            var newView = delegate.getCurrentView();
            Ui.switchToView(newView, delegate, Ui.SLIDE_LEFT );
            return true;
        }
        return false;
    }
}
