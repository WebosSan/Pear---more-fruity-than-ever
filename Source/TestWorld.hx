import pear.components.VelocityComponent;
import pear.components.TransformComponent;
import pear.components.SpriteComponent;
import pear.Entity;
import pear.World;

class TestWorld extends World {
    override function create() {
        super.create();
        trace("Hello :3");
        
        var ralsei:Entity = createEntity();
        ralsei.setComponent(new TransformComponent(ralsei));
        ralsei.setComponent(new SpriteComponent(ralsei, "assets/images/image_test.png"));
        ralsei.setComponent(new VelocityComponent(ralsei));

        ralsei.getComponent(VelocityComponent).x = 30;
        ralsei.getComponent(VelocityComponent).y = 30;
    }
}