package pear.components;

import lime.math.Vector2;

class TransformComponent extends Component {
    public var x:Float = 0;
    public var y:Float = 0;

    public var angle:Float = 0;
    public var scale:Vector2 = new Vector2(1, 1);

    public function new(parent:Entity, x:Float = 0, y:Float = 0) {
        super(parent);
        this.x = x;
        this.y = y;   
    }
}