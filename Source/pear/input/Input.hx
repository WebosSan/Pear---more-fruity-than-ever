package pear.input;

import lime.ui.KeyModifier;
import lime.ui.KeyCode;

class Input {
    @:noCompletion
    public static var pressedKeys:Map<KeyCode, Bool> = new Map();
    @:noCompletion
    public static var justPressedKeys:Map<KeyCode, Bool> = new Map();
    @:noCompletion
    public static var justReleasedKeys:Map<KeyCode, Bool> = new Map();

    public static inline function pressed(k:KeyCode):Bool return pressedKeys.get(k) ?? false;
    public static inline function justPressed(k:KeyCode):Bool return justPressedKeys.get(k) ?? false;
    public static inline function justReleased(k:KeyCode):Bool return justReleasedKeys.get(k) ?? false;

    @:noCompletion
    public static function update() {
        justPressedKeys.clear();
        justReleasedKeys.clear();
    }
    
    @:noCompletion
    public static function onKeyPressed(k:KeyCode, m:KeyModifier) {
        if (!pressedKeys.exists(k) || !pressedKeys.get(k)){
            justPressedKeys.set(k, true);
        }
        pressedKeys.set(k, true);
    }

    @:noCompletion
    public static function onKeyReleased(k:KeyCode, m:KeyModifier) {
        pressedKeys.set(k, false);
        justReleasedKeys.set(k, true);
    }
}