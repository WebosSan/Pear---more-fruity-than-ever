package pear.render.batchs;

import lime.math.Matrix4;
import pear.render.Renderer;
import pear.core.PearEngine;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;

class RectBatch {
	var gl:WebGLRenderContext;
	var shader:Shader;
	var vbo:GLBuffer;
	var posLoc:Int;
	var colorLoc:GLUniformLocation;
	var projectionLoc:GLUniformLocation;
	var translateLoc:GLUniformLocation;
	var customLoc:GLUniformLocation;

	public function new() {
		gl = PearEngine.gl;

		var vertSrc:String = '
        attribute vec2 a_position;
        uniform mat4 u_projection;
        uniform mat4 u_translate;

        void main(void) {
            gl_Position = u_projection * u_translate * vec4(a_position, 0.0, 1.0);
        }
        ';

		var fragSrc:String = '
        uniform vec4 u_color;
        void main(void) {
            gl_FragColor = u_color;
        }
        ';

		shader = new Shader(vertSrc, fragSrc);

		vbo = gl.createBuffer();

		shader.activate();
		posLoc = gl.getAttribLocation(shader.program, "a_position");
		projectionLoc = gl.getUniformLocation(shader.program, "u_projection");
		translateLoc = gl.getUniformLocation(shader.program, "u_translate");
	}

	public function draw(w:Float, h:Float, color:Array<Float>, ?matrix:Matrix4) {
		var verts:Array<Float> = [
			0, 0,
			w, 0,
			0, h,

			w, 0,
			w, h,
			0, h
		];

		shader.activate();

		gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(verts), gl.STREAM_DRAW);

		gl.enableVertexAttribArray(posLoc);
		gl.vertexAttribPointer(posLoc, 2, gl.FLOAT, false, 0, 0);

		gl.uniformMatrix4fv(projectionLoc, false, PearEngine.projection);
		gl.uniformMatrix4fv(translateLoc, false, matrix ?? new Matrix4());

		gl.uniform4f(colorLoc, color[0], color[1], color[2], color[3]);

		gl.drawArrays(gl.TRIANGLES, 0, 6);

		gl.disableVertexAttribArray(posLoc);
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
	}

	public function drawOutline(w:Float, h:Float, color:Array<Float>, thickness:Float = 1, ?matrix:Matrix4) {
		var verts:Array<Float> = [
			0, 0,   
			w, 0,  
			w, h,   
			0, h   
		];
	
		shader.activate();
	
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(verts), gl.STREAM_DRAW);
	
		gl.enableVertexAttribArray(posLoc);
		gl.vertexAttribPointer(posLoc, 2, gl.FLOAT, false, 0, 0);
	
		gl.uniformMatrix4fv(projectionLoc, false, PearEngine.projection);
		gl.uniformMatrix4fv(translateLoc, false, matrix ?? new Matrix4());
		gl.uniform4f(colorLoc, color[0], color[1], color[2], color[3]);
	
		gl.lineWidth(thickness);
	
		gl.drawArrays(gl.LINE_LOOP, 0, 4);
	
		gl.disableVertexAttribArray(posLoc);
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
	
		gl.lineWidth(1);
	}	
	

	public function destroy() {
		shader.destroy();
		PearEngine.gl.deleteBuffer(vbo);
	}
}
