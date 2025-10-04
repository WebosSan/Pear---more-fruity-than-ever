package pear.components;

class Component {
    public var parent:Entity;
    public function new(parent:Entity) {
        this.parent = parent;

        parent.onUpdate.add(update);
        parent.onRender.add(render);
    }

    public function update(dt:Float) {
        
    }

    public function render() {
        
    }
}