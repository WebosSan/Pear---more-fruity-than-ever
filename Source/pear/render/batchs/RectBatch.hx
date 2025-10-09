package pear.render.batchs;

import pear.system.PearGL;
import lime.math.Vector2;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;
import lime.math.Matrix4;
import pear.utils.Color;
import pear.core.PearEngine;
import pear.utils.MathUtils;

class RectBatch {
    #if lime_webgl
    static var vertexSrc = "
        attribute vec2 a_position;
        attribute vec4 a_color;
        uniform mat4 u_projection;
        varying vec4 v_color;

        void main() {
            v_color = a_color;
            gl_Position = u_projection * vec4(a_position, 0.0, 1.0);
        }
    ";

    static var fragmentSrc = "
        precision mediump float;
        varying vec4 v_color;
        void main() {
            gl_FragColor = v_color;
        }
    ";
    #else
    static var vertexSrc = "
        attribute vec2 a_position;
        attribute vec4 a_color;
        uniform mat4 u_projection;
        varying vec4 v_color;

        void main() {
            v_color = a_color;
            gl_Position = u_projection * vec4(a_position, 0.0, 1.0);
        }
    ";

    static var fragmentSrc = "
        varying vec4 v_color;
        void main() {
            gl_FragColor = v_color;
        }
    ";
    #end

    private static var shader:Shader;
    private static var u_projection:GLUniformLocation;
    private static var a_position:Int;
    private static var a_color:Int;
    private static var vbo:GLBuffer;

    static inline var MAX_RECTS:Int = 1000;
    static inline var FLOATS_PER_VERTEX:Int = 6;
    static inline var FLOATS_PER_RECT:Int = FLOATS_PER_VERTEX * 6;

    private static var vertexData:Float32Array;
    private static var vertexCount:Int = 0;

    public static function init() {
        shader = new Shader(vertexSrc, fragmentSrc);
        shader.activate();

        a_position = gl.getAttribLocation(shader.program, "a_position");
        a_color = gl.getAttribLocation(shader.program, "a_color");
        u_projection = gl.getUniformLocation(shader.program, "u_projection");

        shader.deactivate();

        vertexData = new Float32Array(MAX_RECTS * FLOATS_PER_RECT);

        vbo = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, vbo);

        PearGL.bufferData(gl.ARRAY_BUFFER, vertexData, gl.DYNAMIC_DRAW);

        gl.bindBuffer(gl.ARRAY_BUFFER, null);
    }

    public static function drawRectangle(width:Float, height:Float, color:Color, ?matrix:Matrix4) {
        if (vertexCount + 6 > MAX_RECTS * 6)
            flush();

        if (matrix == null)
            matrix = MathUtils.identityMatrix;

        inline function push(x:Float, y:Float) {
            var v:Vector2 = MathUtils.applyMatrixToCoordinates(x, y, matrix);
            var i:Int = vertexCount * FLOATS_PER_VERTEX;
            vertexData[i] = v.x;
            vertexData[i + 1] = v.y;
            vertexData[i + 2] = color.redFloat;
            vertexData[i + 3] = color.greenFloat;
            vertexData[i + 4] = color.blueFloat;
            vertexData[i + 5] = color.alphaFloat;
            vertexCount++;
        }

        push(0, 0);
        push(width, 0);
        push(0, height);
        push(width, 0);
        push(width, height);
        push(0, height);
    }

    public static function flush() {
        if (vertexCount == 0)
            return;

        shader.activate();

        PearGL.uniformMatrix4fv(u_projection, false, PearEngine.projection);

        gl.bindBuffer(gl.ARRAY_BUFFER, vbo);

        PearGL.bufferSubData(gl.ARRAY_BUFFER, vertexData.subarray(0, vertexCount * FLOATS_PER_VERTEX));

        gl.enableVertexAttribArray(a_position);
        gl.enableVertexAttribArray(a_color);

        var stride:Int = FLOATS_PER_VERTEX * Float32Array.BYTES_PER_ELEMENT;
        gl.vertexAttribPointer(a_position, 2, gl.FLOAT, false, stride, 0);
        gl.vertexAttribPointer(a_color, 4, gl.FLOAT, false, stride, 2 * Float32Array.BYTES_PER_ELEMENT);

        gl.drawArrays(gl.TRIANGLES, 0, vertexCount);

        vertexCount = 0;
        shader.deactivate();
    }

    public static function destroy() {
        gl.deleteBuffer(vbo);
        gl.deleteProgram(shader.program);
    }
}
