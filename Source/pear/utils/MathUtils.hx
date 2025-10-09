package pear.utils;

import lime.math.Vector2;
import lime.math.Matrix4;

class MathUtils {
    public static var identityMatrix:Matrix4 = createIdentityMatrix();

    public static function createIdentityMatrix():Matrix4 {
        var m:Matrix4 = new Matrix4();
        m.identity();
        return m;
    }

    public static function applyMatrixToCoordinates(x:Float, y:Float, m:Matrix4):Vector2 {
        var tx:Float = m[0] * x + m[4] * y + m[12];
        var ty:Float = m[1] * x + m[5] * y + m[13];
        return new Vector2(tx, ty);
    }    
}