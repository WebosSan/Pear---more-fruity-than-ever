package pear.components;

import pear.render.ExperimentalRenderer;
import lime.math.Matrix4;
import lime.math.Vector4;

class RectComponent extends Component {
    public var width:Float;
    public var height:Float;
    public var color:Int;

    public function new(parent:Entity, width:Float, height:Float, color:Int = 0xFFFFFFFF) {
        super(parent);
        this.width = width;
        this.height = height;
        this.color = color;
    }

    override function render() {
        super.render();

        var transform:TransformComponent = parent.hasComponent(TransformComponent) 
            ? parent.getComponent(TransformComponent) 
            : new TransformComponent(parent);

        var model:Matrix4 = new Matrix4();
        model.identity();

        model.appendTranslation(-width / 2, -height / 2, 0);
        model.appendScale(transform.scale.x, transform.scale.y, 1);
        model.appendRotation(transform.angle, new Vector4(0, 0, 1, 0));
        model.appendTranslation(width / 2, height / 2, 0);
        model.appendTranslation(transform.x, transform.y, 0);

        ExperimentalRenderer.drawRectangle(width, height, color, model);
    }
}
