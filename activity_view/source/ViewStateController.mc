using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Storage as Storage;

class ViewStateController extends Ui.InputDelegate {

    const KEY_LOADLASTVIEWSTATE = "LoadLastViewState";
    const KEY_LASTVIEWSTATE = "LastViewState";

    const VIEW_COUNT = 5;

    public var viewState = 0;

    // Constructor
    function initialize() {
        Ui.InputDelegate.initialize();
        var loadLastViewState = App.getApp().getProperty(KEY_LOADLASTVIEWSTATE);
        if ( loadLastViewState != null && loadLastViewState == true ) {
            var lastViewState = App.getApp().getProperty(KEY_LASTVIEWSTATE);
            //var lastViewState = Storage.getValue(KEY_LASTVIEWSTATE);
            if ( lastViewState != null && lastViewState < VIEW_COUNT ) {
                viewState = lastViewState;
            }
            else {
                viewState = 0;
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
          return new ViewDetailsCalories(self);
        }
        else if ( viewState == 2 ) {
          return new ViewDetailsSteps(self);
        }
        else if ( viewState == 3 ) {
          return new ViewDetailsDistance(self);
        }
        else if ( viewState == 4 ) {
          return new ViewOverlay(self);
        }
        else {
          return new ViewSummary(self);
        }
    }

    function onKey(evt) {
        if (evt.getKey() == Ui.KEY_ENTER) {
            var delegate = new ViewStateController();
            viewState = (viewState + 1 ) % VIEW_COUNT;
            delegate.setState(viewState);

            var newView = delegate.getCurrentView();
            Ui.switchToView(newView, delegate, Ui.SLIDE_LEFT );
            return true;
        }
        return false;
    }
}
