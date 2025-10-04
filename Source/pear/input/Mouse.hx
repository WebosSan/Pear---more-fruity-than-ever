package pear.input;

import lime.ui.MouseButton;

class Mouse {
    public static var screenX:Float = 0;
    public static var screenY:Float = 0;

    public static var deltaScreenX:Float = 0;
    public static var deltaScreenY:Float = 0;

    public static var pressed:Bool = false;
    public static var justPressed:Bool = false;
    public static var justReleased:Bool = false;

    public static var pressedRight:Bool = false;
    public static var justPressedRight:Bool = false;
    public static var justReleasedRight:Bool = false;

    public static var pressedCenter:Bool = false;
    public static var justPressedCenter:Bool = false;
    public static var justReleasedCenter:Bool = false;

    @:noCompletion public static function onMouseMove(x:Float, y:Float) {
        screenX = x;
        screenY = y;
    }

    @:noCompletion public static function onMouseMoveRelative(dx:Float, dy:Float) {
        deltaScreenX = dx;
        deltaScreenY = dy;
    }

    @:noCompletion public static function update() {
        justPressed = false;
        justReleased = false;

        justPressedRight = false;
        justReleasedRight = false;

        justPressedCenter = false;
        justReleasedCenter = false;
    }

    @:noCompletion public static function onMouseDown(f1:Float, f2:Float, button:MouseButton) {
        switch (button){
            case LEFT:
                if (!pressed) justPressed = true;
                pressed = true;
            case RIGHT:
                if (!pressedRight) justPressedRight = true;
                pressedRight = true;
            case MIDDLE:
                if (!pressedCenter) justPressedCenter = true;
                pressedCenter = true;
        }
    }

    @:noCompletion public static function onMouseUp(f1:Float, f2:Float, button:MouseButton) {
        switch (button){
            case LEFT:
                justReleased = true;
                pressed = false;
            case RIGHT:
                justReleasedRight = true;
                pressedRight = false;
            case MIDDLE:
                justReleasedCenter = true;
                pressedCenter = false;
        }
    }
}