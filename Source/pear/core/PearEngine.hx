package pear.core;

import lime.app.Event;
import pear.system.CacheBackend;
import pear.input.Mouse;
import pear.input.Input;
import lime.math.Vector4;
import lime.math.Matrix4;
import pear.render.Renderer;
import lime.graphics.WebGLRenderContext;
import lime.graphics.RenderContextType;
import lime.app.Application;
import lime.graphics.RenderContext;

enum DisplayMode {
    DEFAULT;
    LETTERBOX;
}

class PearEngine {
    private static var supportedContexts:Array<RenderContextType> = [WEBGL, OPENGL, OPENGLES];
    public static var current:PearEngine;

    public static var projection:Matrix4;
    public static var gl:WebGLRenderContext;
    public static var parent:Application;
    public static var world:Scene;

    private var onInitialize(default, null) = new Event<Void->Void>();
    private var _initialized:Bool = false;
    private var _nextWorld:Class<Scene>;

    public static var displayMode:DisplayMode = DisplayMode.LETTERBOX;
    public static var targetWidth:Int = 0;  
    public static var targetHeight:Int = 0;

    public function new(parent:Application, world:Class<Scene>) {
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

		targetWidth = Application.current.window.width;
		targetHeight = Application.current.window.height;

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

        var winW:Int = parent.window.width;
        var winH:Int = parent.window.height;

        switch (displayMode) {
            case DEFAULT:
                projection.createOrtho(0, winW, winH, 0, -1000, 1000);
                gl.viewport(0, 0, winW, winH);

            case LETTERBOX:
                var targetRatio:Float = targetWidth / targetHeight;
                var windowRatio:Float = winW / winH;

                var vpW:Int = winW;
                var vpH:Int = winH;

                if (windowRatio > targetRatio) {
                    vpH = winH;
                    vpW = Math.floor(vpH * targetRatio);
                } else {
                    vpW = winW;
                    vpH = Math.floor(vpW / targetRatio);
                }

                var vpX:Int = Math.floor((winW - vpW) / 2);
                var vpY:Int = Math.floor((winH - vpH) / 2);

                gl.viewport(vpX, vpY, vpW, vpH);
                projection.createOrtho(0, targetWidth, targetHeight, 0, -1000, 1000);

                gl.enable(gl.SCISSOR_TEST);
                gl.clearColor(0, 0, 0, 1);

                gl.scissor(0, vpY + vpH, winW, winH - (vpY + vpH));
                gl.clear(gl.COLOR_BUFFER_BIT);

                gl.scissor(0, 0, winW, vpY);
                gl.clear(gl.COLOR_BUFFER_BIT);

                gl.scissor(0, vpY, vpX, vpH);
                gl.clear(gl.COLOR_BUFFER_BIT);

                gl.scissor(vpX + vpW, vpY, winW - (vpX + vpW), vpH);
                gl.clear(gl.COLOR_BUFFER_BIT);

                gl.disable(gl.SCISSOR_TEST);
        }

        if (world != null)
            world.render();
    }

    public function update(dt:Float) {
        if (!_initialized) return;

        if (_nextWorld != null) {
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
        CacheBackend.clearCache();
    }
}
