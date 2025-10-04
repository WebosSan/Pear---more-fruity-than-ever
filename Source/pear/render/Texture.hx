package pear.render;

import lime.utils.Assets;
import lime.graphics.Image;
import pear.core.PearEngine;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLTexture;

class Texture {
    public var glTexture:GLTexture;
    public var image:Image;

    public var width(get, never):Int;
    public var height(get, never):Int;

    public function new(path:String) {
        image = Assets.getImage(path);
        uploadTexture();
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
        PearEngine.gl.bindTexture(PearEngine.gl.TEXTURE_2D, glTexture);
    }

    public function unbind():Void {
        PearEngine.gl.bindTexture(PearEngine.gl.TEXTURE_2D, null);
    }

    public function destroy():Void {PearEngine.gl.deleteTexture(glTexture);}; 

    private function get_width():Int return image.width;
    private function get_height():Int return image.height;
}
