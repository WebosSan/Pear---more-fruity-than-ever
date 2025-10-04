package pear;

import pear.components.Component;
import lime.app.Event;
import pear.components.TransformComponent;
import haxe.ds.Map;

class Entity {
    public var components:Map<String, Dynamic>;
    
	public var onUpdate(default, null) = new Event<Float->Void>();
	public var onRender(default, null) = new Event<Void->Void>();

    public function new() {
        components = new Map();
    }

    public function setComponent<T:Component>(c:T):Void {
        components.set(Type.getClassName(Type.getClass(c)), c);
    }

    public function getComponent<T:Component>(cls:Class<T>):Null<T> {
        return cast components.get(Type.getClassName(cls));
    }

    public function hasComponent<T:Component>(cls:Class<T>):Bool {
        return components.exists(Type.getClassName(cls));
    }

    public function removeComponent<T:Component>(cls:Class<T>):Void {
        components.remove(Type.getClassName(cls));
    }

    public function update(dt:Float) {
        onUpdate.dispatch(dt);
    }

    public function render() {
        onRender.dispatch();
    }
}
