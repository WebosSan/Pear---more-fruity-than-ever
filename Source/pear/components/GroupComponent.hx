package pear.components;

class GroupComponent extends Component {
    public var entities:Array<Entity>;

    public function new(parent:Entity) {
        super(parent);
        entities = [];
    }

    public function add(entity:Entity):Entity {
        if (entities.indexOf(entity) < 0){
            entities.push(entity);
        }
        return entity;
    }

    public function remove(entity:Entity) {
        entities.remove(entity);
    }

    override function render() {
        super.render();
        for (entity in entities) entity.render();
    }

    override function update(dt:Float) {
        super.update(dt);
        for (entity in entities) entity.update(dt);
    }
}