using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Storage as Storage;

class ColorScheme {
    const KEY_COLORSCHEME = "ColorScheme";

    const VALUE_COLORSCHEME_B = 0;
    const VALUE_COLORSCHEME_W = 1;

    private var colorScheme = VALUE_COLORSCHEME_B;

    // color scheme values
    public var colorFg;
    public var colorFg2;
    public var colorBg;
    public var colorLine;
    public var colorAvg;
    public var colorNow;
    public var colorCal;
    public var colorCalShadow;
    public var colorStep;
    public var colorStepShadow;
    public var colorDist;
    public var colorDistShadow;

    public function initialize() {
        var selectedColorScheme = App.getApp().getProperty(KEY_COLORSCHEME);
        if ( selectedColorScheme != null && selectedColorScheme instanceof Toybox.Lang.Number ) {
            colorScheme = selectedColorScheme;
        }
        if ( colorScheme == VALUE_COLORSCHEME_W ) {
            colorFg = Gfx.COLOR_BLACK;
            colorBg = Gfx.COLOR_WHITE;
        }
        else {
            colorFg = Gfx.COLOR_WHITE;
            colorBg = Gfx.COLOR_BLACK;
        }
        colorFg2 = Gfx.COLOR_LT_GRAY;
        colorAvg = Gfx.COLOR_GREEN;
        colorLine = Gfx.COLOR_DK_GRAY;
        colorNow = Gfx.COLOR_DK_GRAY;
        colorCal = Gfx.COLOR_BLUE;
        colorCalShadow = Gfx.COLOR_DK_BLUE;
        colorStep = Gfx.COLOR_YELLOW;
        colorStepShadow = Gfx.COLOR_ORANGE;
        colorDist = Gfx.COLOR_PINK;
        colorDistShadow = Gfx.COLOR_DK_RED;
    }

}


