package pear.groups;

import pear.components.GroupComponent;

class Group extends Entity {
    public var entities(get, set):Array<Entity>;
    public var groupComponent:GroupComponent;

    public function new() {
        super();
        groupComponent = setComponent(new GroupComponent(this));
    }

    public function add(entity:Entity):Entity {
        return groupComponent.add(entity);
    }

    public function remove(entity:Entity) {
        return groupComponent.remove(entity);
    }
    
    @:noCompletion private function get_entities():Array<Entity> {
        return groupComponent.entities;
    }

    @:noCompletion private function set_entities(value:Array<Entity>) {
        return groupComponent.entities = value;
    }
}