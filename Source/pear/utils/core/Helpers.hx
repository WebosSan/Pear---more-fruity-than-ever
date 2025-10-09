package pear.utils.core;

import lime.graphics.OpenGLRenderContext;
import lime.graphics.OpenGLES3RenderContext;
import lime.graphics.WebGL2RenderContext;
import pear.core.PearEngine;
import lime.graphics.WebGLRenderContext;

class Helpers {
    public static var gl(get, never):#if html5 WebGL2RenderContext #else OpenGLRenderContext #end;

    static function get_gl() {
        return PearEngine.gl;
    }
}