package pear.render;

import lime.math.Matrix4;
import pear.utils.Color;
import pear.render.batchs.RectBatch;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;

class ExperimentalRenderer {

    public static function init() {
        RectBatch.init();
    }    

    public static function drawRectangle(width:Float, height:Float, color:Color, ?matrix:Matrix4) {
        RectBatch.drawRectangle(width, height, color, matrix);
    }

    public static function flush() {
        RectBatch.flush();
    }

    public static function destroy() {
        RectBatch.destroy();
    }
}