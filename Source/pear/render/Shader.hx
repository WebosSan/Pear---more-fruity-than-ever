package pear.render;

import lime.graphics.opengl.GL;
import pear.system.CacheBackend;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import pear.core.PearEngine;

class Shader {
	public var program:GLProgram;

	public var vertexContent(default, set):String;
	public var fragmentContent(default, set):String;

	#if !desktop
	var prefix:String = "precision mediump float;\n";
	#else
	var prefix:String = "";
	#end

	public function new(vertSource:String, fragSource:String) {
		var gl:WebGLRenderContext = PearEngine.gl;
		program = CacheBackend.getProgram(vertSource, prefix + fragSource);

		vertexContent = vertSource;
		fragmentContent = fragSource;
	}

	public function activate() {
		gl.useProgram(program);
	}

	public function deactivate() {
		gl.useProgram(null);
	}

	private function set_vertexContent(v:String):String {
		if (vertexContent != null && fragmentContent != null) program = CacheBackend.getProgram(v, prefix + fragmentContent);
		return vertexContent = v;
	}

	private function set_fragmentContent(v:String):String {
		if (vertexContent != null && fragmentContent != null) program = CacheBackend.getProgram(vertexContent, prefix + v);
		return vertexContent = v;
	}
}
