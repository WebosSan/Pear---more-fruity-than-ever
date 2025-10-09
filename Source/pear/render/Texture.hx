package pear.render;

import lime.graphics.Image;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLTexture;
import lime.utils.ArrayBufferView;
import pear.core.PearEngine;

class Texture {
    public var glTexture:GLTexture;
    public var image:Image;
    public var width(get, never):Int;
    public var height(get, never):Int;

    public function new(width:Int, height:Int, color:Int = 0xFFFFFFFF) {
        var gl = PearEngine.gl;
        image = new Image(null, 0, 0, width, height, color);

        glTexture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, glTexture);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

        #if js
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image.src);
        #else
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
        #end

        gl.bindTexture(gl.TEXTURE_2D, null);
    }

    public static function fromFile(path:String):Texture {
        var tex = new Texture(1, 1); 
        tex.image = Image.fromFile(path);
        tex.uploadTexture();
        return tex;
    }


    public static function createWhite():Texture {
        return new Texture(1, 1, 0xFFFFFFFF);
    }

    private function uploadTexture():Void {
        var gl:WebGLRenderContext = PearEngine.gl;

        if (glTexture != null) gl.deleteTexture(glTexture);

        glTexture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, glTexture);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

        #if js
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image.src);
        #else
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, image.buffer.width, image.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
        #end

        gl.bindTexture(gl.TEXTURE_2D, null);
    }

    public function bind():Void {
        var gl = PearEngine.gl;
        gl.bindTexture(gl.TEXTURE_2D, glTexture);
    }

    public function unbind():Void {
        var gl = PearEngine.gl;
        gl.bindTexture(gl.TEXTURE_2D, null);
    }

    public function destroy():Void {
        var gl = PearEngine.gl;
        if (glTexture != null) gl.deleteTexture(glTexture);
    }

    private function get_width():Int return image.width;
    private function get_height():Int return image.height;
}