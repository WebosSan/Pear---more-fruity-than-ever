package pear;

import pear.core.PearEngine;
import lime.app.Event;

class Scene {
    public var entities:Array<Entity>;
    
    public var onUpdate(default, null) = new Event<Float->Void>();
	public var onRender(default, null) = new Event<Void->Void>();

    public function new(p:PearEngine) {
        entities = [];
    } 
    
    public function create() {}

    public function createEntity():Entity {
        var entity:Entity = new Entity();
        entities.push(entity);
        return entity;
    }

    public function update(dt:Float) {
        for (entity in entities) entity.update(dt);
        onUpdate.dispatch(dt);
    }

    public function render() {
        for (entity in entities) entity.render();
        onRender.dispatch();
    }
}