using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Storage as Storage;

class UiHelperBase {
    var colors;

    // layouting
    var dc;
    var width;
    var height;
    // max width of data row box
    var maxWidth;

    function initialize(aColorScheme) {
        colors = aColorScheme;
    }

    function initLayout(aDc) {
        dc = aDc;
        width = dc.getWidth();
        height = dc.getHeight();
        maxWidth = width;
    }

    public function draw() {
    }

    public function getDisplayValue(value) {
        if ( value instanceof Toybox.Lang.Double || value instanceof Toybox.Lang.Float) {
            if ( value > 9999 ) {
                return value.format("%d");
            }
            else {
                return value.format("%.1f");
            }
        }
        else if ( value instanceof Toybox.Lang.Number ) {
            if ( value > 99999 ) {
                return ">99999";
            }
            else {
                return value.format("%d");
            }
        }
        else {
          return value;
        }
    }

}


