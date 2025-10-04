package pear.components;

class VelocityComponent extends Component{
    public var x:Float = 0;
    public var y:Float = 0;

    public function new(parent:Entity) {
        super(parent);
    }

    override function update(dt:Float) {
        super.update(dt);
        if (parent.hasComponent(TransformComponent)){
            var transform:TransformComponent = parent.getComponent(TransformComponent);
            transform.x += x * dt;
            transform.y += y * dt;
        }
    }
}