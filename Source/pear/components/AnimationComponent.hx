package pear.components;

import pear.animations.AnimationController;

class AnimationComponent extends SpriteComponent {
    public var defaultFrameWitdh:Float = 0;
    public var defaultFrameHeight:Float = 0;

    public var animation:AnimationController;

	public function new(parent:Entity, path:String, ?frameWidth:Float = 0, ?frameHeight:Float = 0) {
		super(parent, path);
        this.defaultFrameHeight = frameHeight;
        this.defaultFrameWitdh = frameWidth;

        animation = new AnimationController(this);
	}

    override function update(dt:Float) {
        super.update(dt);
        animation.update(dt);
    }
    
    override function render() {
        animation.render();
    }
}