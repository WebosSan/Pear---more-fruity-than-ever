import pear.input.Input;
import pear.components.AnimationComponent;
import pear.components.VelocityComponent;
import pear.components.TransformComponent;
import pear.components.SpriteComponent;
import pear.Entity;
import pear.World;

class TestWorld extends World {
    var boyfriend:Entity;
    var bfAnimation:AnimationComponent;
    
    override function create() {
        super.create();
        
        boyfriend = createEntity();
        boyfriend.setComponent(new AnimationComponent(boyfriend, "assets/images/BOYFRIEND.png", 200, 200));
        
        bfAnimation = boyfriend.getComponent(AnimationComponent);

        bfAnimation.animation.generateFromSparrow("assets/images/BOYFRIEND.xml");
        bfAnimation.animation.addAnimationByPrefix("idle", "BF idle dance", 24, true);
        bfAnimation.animation.addAnimationByPrefix("singUp", "BF NOTE UP0", 24, false);
        bfAnimation.animation.addAnimationByPrefix("singLeft", "BF NOTE LEFT0", 24, false);
        bfAnimation.animation.addAnimationByPrefix("singRight", "BF NOTE RIGHT0", 24, false);
        bfAnimation.animation.addAnimationByPrefix("singDown", "BF NOTE DOWN0", 24, false);
        bfAnimation.animation.playAnimation("idle");
    }

    override function update(dt:Float) {
        super.update(dt);
        if (Input.justPressed(UP)) bfAnimation.animation.playAnimation("singUp");
        if (Input.justPressed(DOWN)) bfAnimation.animation.playAnimation("singDown");
        if (Input.justPressed(LEFT)) bfAnimation.animation.playAnimation("singLeft");
        if (Input.justPressed(RIGHT)) bfAnimation.animation.playAnimation("singRight");
    }
}