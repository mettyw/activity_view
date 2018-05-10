using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Storage as Storage;

class UiHelperBase {
    const KEY_COLORSCHEME = "ColorScheme";

    const VALUE_COLORSCHEME_B = 0;
    const VALUE_COLORSCHEME_W = 1;

    var colorScheme = VALUE_COLORSCHEME_B;

    // color scheme values
    var colorFg;
    var colorFg2;
    var colorBg;
    var colorLine;
    var colorAvg;
    var colorNow;
    var colorCal;
    var colorCalShadow;
    var colorStep;
    var colorStepShadow;
    var colorDist;
    var colorDistShadow;

    // layouting
    var dc;
    var width;
    var height;
    // max width of data row box
    var maxWidth;

    function initialize() {
        var selectedColorScheme = App.getApp().getProperty(KEY_COLORSCHEME);
        if ( selectedColorScheme != null && selectedColorScheme instanceof Toybox.Lang.Number ) {
            colorScheme = selectedColorScheme;
        }
    }

    function initColors() {
        if ( colorScheme == VALUE_COLORSCHEME_W ) {
            colorFg = Gfx.COLOR_BLACK;
            colorBg = Gfx.COLOR_WHITE;
        }
        else {
            colorFg = Gfx.COLOR_WHITE;
            colorBg = Gfx.COLOR_BLACK;
        }
        colorFg2 = Gfx.COLOR_LT_GRAY;
        colorAvg = Gfx.COLOR_PINK;
        colorLine = Gfx.COLOR_DK_GRAY;
        colorNow = Gfx.COLOR_DK_GRAY;
        colorCal = Gfx.COLOR_BLUE;
        colorCalShadow = Gfx.COLOR_DK_BLUE;
        colorStep = Gfx.COLOR_YELLOW;
        colorStepShadow = Gfx.COLOR_ORANGE;
        colorDist = Gfx.COLOR_GREEN;
        colorDistShadow = Gfx.COLOR_DK_GREEN;
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


