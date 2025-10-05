package pear.sounds;

import pear.system.CacheBackend;
import lime.media.AudioBuffer;
import lime.media.AudioSource;
import lime.utils.Assets;
import haxe.Timer;

class Sound {
    public var buffer:AudioBuffer;
    public var source:AudioSource;
    public var path:String;

    private var _playing:Bool = false;
    private var _paused:Bool = false;
    private var _loop:Bool = false;
    private var startTime:Float = 0.0;

    public var playing(get, never):Bool;
    public var paused(get, never):Bool;
    public var loop(get, set):Bool;
    public var gain(get, set):Float;
    public var pitch(get, set):Float;
    public var time(get, never):Float;

    public function new(path:String) {
        this.path = path;
        load(path);
    }

    private function load(path:String):Void {
        try {
            buffer = CacheBackend.getAudio(path);

            if (buffer == null)
                throw "Couldnt load sound: " + path;

            source = new AudioSource(buffer);
        } catch (e:Dynamic) {
            trace("Error loading sound " + e);
        }
    }

    public function play(loop:Bool = false, gain:Float = 1.0, pitch:Float = 1.0):Void {
        if (source == null) return;

        _loop = loop;

        source.gain = gain;
        source.pitch = pitch;
        source.loops = loop ? -1 : 0;

        source.play();
        _playing = true;
        _paused = false;
        startTime = Timer.stamp();
    }

    public function pause():Void {
        if (source != null && _playing) {
            source.pause();
            _paused = true;
            _playing = false;
        }
    }

    public function stop():Void {
        if (source != null) {
            source.stop();
            _playing = false;
            _paused = false;
        }
    }

    public function dispose():Void {
        if (source != null) source.stop();
        source = null;
        buffer = null;
        _playing = false;
    }

    function get_playing():Bool return _playing;
    function get_paused():Bool return _paused;

    function get_loop():Bool return _loop;
    function set_loop(v:Bool):Bool {
        _loop = v;
        if (source != null)
            source.loops = v ? -1 : 0;
        return v;
    }

    function get_gain():Float return source.gain;
    function set_gain(v:Float):Float {
        return source.gain = v;
    }

    function get_pitch():Float return source.pitch;
    function set_pitch(v:Float):Float {
        return source.pitch = v;
    }

    function get_time():Float {
        return source.currentTime;
    }
}
