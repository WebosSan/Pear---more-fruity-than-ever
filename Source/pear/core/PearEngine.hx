package pear.core;

import lime.app.Event;
import pear.system.AssetsBackend;
import pear.input.Mouse;
import pear.input.Input;
import lime.math.Vector4;
import lime.math.Matrix4;
import pear.render.Renderer;
import lime.graphics.WebGLRenderContext;
import lime.graphics.RenderContextType;
import lime.app.Application;
import lime.graphics.RenderContext;

class PearEngine {
	private static var supportedContexts:Array<RenderContextType> = [WEBGL, OPENGL, OPENGLES];
	public static var current:PearEngine;

	public static var projection:Matrix4;

	public static var gl:WebGLRenderContext;
	public static var parent:Application;

	public static var world:World;

	private var onInitialize(default, null) = new Event<Void->Void>();
	private var _initialized:Bool = false;

	private var _nextWorld:Class<World>;

	public function new(parent:Application, world:Class<World>) {
		if (current != null)
			throw "Error, cannot create 2 engines.";

		PearEngine.parent = parent;
		_nextWorld = world;
		current = this;

		Application.current.onUpdate.add(update);
		Application.current.window.onRender.add(render);

		Application.current.window.onKeyDown.add(Input.onKeyPressed);
		Application.current.window.onKeyUp.add(Input.onKeyReleased);

		Application.current.window.onMouseMove.add(Mouse.onMouseMove);
		Application.current.window.onMouseMoveRelative.add(Mouse.onMouseMoveRelative);
		Application.current.window.onMouseDown.add(Mouse.onMouseDown);
		Application.current.window.onMouseUp.add(Mouse.onMouseUp);
		Application.current.window.onClose.add(onQuit);

		onInitialize.add(Renderer.init);

		projection = new Matrix4();
	}

	public function render(context:RenderContext) {
		if (!supportedContexts.contains(context.type))
			throw "Unsopported context: " + context.type;
		if (!parent.preloader.complete)
			return;

		gl = context.webgl;

		if (!_initialized) onInitialize.dispatch();

		_initialized = true;

		var r = ((context.attributes.background >> 16) & 0xFF) / 0xFF;
		var g = ((context.attributes.background >> 8) & 0xFF) / 0xFF;
		var b = (context.attributes.background & 0xFF) / 0xFF;

		gl.clearColor(r, g, b, 1);
		gl.clear(gl.COLOR_BUFFER_BIT);

		projection.createOrtho(0, parent.window.width, parent.window.height, 0, -1000, 1000);
		gl.viewport(0, 0, parent.window.width, parent.window.height);

		if (world != null)
			world.render();
	}

	public function update(dt:Float) {
		if (!_initialized) return;

		if (_nextWorld != null){
			world = Type.createInstance(_nextWorld, [this]);
			world.create();
			_nextWorld = null;
		}
		
		if (world != null)
			world.update(dt / 1000);

		Input.update();
		Mouse.update();
	}

	public function onQuit() {
		Renderer.destroy();
		AssetsBackend.clearCache();
	}
}
