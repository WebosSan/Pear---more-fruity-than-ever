package pear.system;

import pear.render.Texture;

class AssetsBackend {
    private static var _textureCache:Map<String, Texture>;

    public static function init() {
        _textureCache = new Map();
    }

    public static function getTexture(path:String):Texture {
        if (_textureCache.exists(path)) return _textureCache.get(path);

        var texture:Texture = new Texture(path);
        _textureCache.set(path, texture);
        return texture;
    }

    public static function clearCache() {
        for (texture in _textureCache){
            texture.destroy();
        }
    }
}