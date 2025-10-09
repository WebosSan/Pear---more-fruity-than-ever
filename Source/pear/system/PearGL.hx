package pear.system;

import lime.math.Matrix4;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.ArrayBufferView;

class PearGL {
    public static function bufferData(type:Int, data:ArrayBufferView, usage:Int) {
        #if html5
        gl.bufferData(type, data, usage);
        #else
        gl.bufferData(type, data.length * 4, data, usage);
        #end
    }

    public static function bufferSubData(type:Int, data:ArrayBufferView) {
        #if html5
        gl.bufferSubData(type, 0, data);
        #else
        gl.bufferSubData(type, 0, data.length * 4, data);
        #end
    }

    public static function uniformMatrix4fv(uniform:GLUniformLocation, transpose:Bool, matrix:Matrix4) {
        #if html5
        gl.uniformMatrix4fv(uniform, transpose, matrix);
        #else
        gl.uniformMatrix4fv(uniform, 1, transpose, matrix);
        #end
    }
}