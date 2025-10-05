package pear.render;

import pear.system.CacheBackend;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import pear.core.PearEngine;

class Shader {
	public var program:GLProgram;

	public function new(vertSource:String, fragSource:String) {
		var gl:WebGLRenderContext = PearEngine.gl;

		#if !desktop
		var prefix:String = "precision mediump float;\n";
		#else
		var prefix:String = "";
		#end
		program = CacheBackend.getProgram(vertSource, prefix + fragSource);
	}

	public function activate() {
		PearEngine.gl.useProgram(program);
	}

	public function deactivate() {
		PearEngine.gl.useProgram(null);
	}
}
