package pear.system;

import pear.core.PearEngine;
import lime.graphics.opengl.GLProgram;
import lime.utils.Assets;
import lime.media.AudioBuffer;
import pear.render.Texture;

typedef ShaderValues = {
    vertex:String,
    fragment:String
}

class CacheBackend {
    private static var _textureCache:Map<String, Texture>;
    private static var _audioCache:Map<String, AudioBuffer>;
    private static var _shaderCache:Map<ShaderValues, GLProgram>;

    public static function init() {
        _textureCache = new Map();
        _audioCache = new Map();
        _shaderCache = new Map();
    }

    public static function getTexture(path:String):Texture {
        if (_textureCache.exists(path)) return _textureCache.get(path);

        var texture:Texture = Texture.fromFile(path);
        _textureCache.set(path, texture);
        return texture;
    }

    public static function getAudio(path:String):AudioBuffer {
        if (_audioCache.exists(path)) return _audioCache.get(path);

        var buffer:AudioBuffer = Assets.getAudioBuffer(path);
        _audioCache.set(path, buffer);
        return buffer;
    }

    public static function getProgram(vertex:String, fragment:String):GLProgram {
        var shader:ShaderValues = {
            vertex: vertex,
            fragment: fragment
        };

        if (_shaderCache.exists(shader)) return _shaderCache.get(shader);
        
        var program:GLProgram = GLProgram.fromSources(PearEngine.gl, vertex, fragment);
        _shaderCache.set(shader, program);
        return program;
    }

    public static function clearCache() {
        for (texture in _textureCache) {
            try texture.destroy() catch (_) {}
        }
        for (buffer in _audioCache) {
            try buffer.dispose() catch (_) {}
        }
        for (program in _shaderCache){
            try gl.deleteProgram(program) catch (_) {};
        }
        _textureCache.clear();
        _audioCache.clear();
    }
    
}