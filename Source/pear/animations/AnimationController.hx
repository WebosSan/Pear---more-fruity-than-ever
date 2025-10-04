package pear.animations;

import lime.math.Vector4;
import lime.math.Matrix4;
import lime.utils.Assets;
import pear.render.Renderer;
import pear.components.AnimationComponent;
import pear.components.TransformComponent;
import haxe.xml.Access;

class AnimationController {
    public var frames:Array<Frame> = [];
    public var animations:Array<Animation> = [];

    public var currentAnimation:Animation;
    public var currentFrame:Frame;

    private var parent:AnimationComponent;
    private var currentIndex:Float;
    private var stopped:Bool = false;

    public function new(parent:AnimationComponent) {
        this.parent = parent;

        @:privateAccess
        generateFramesFromSheet(parent._texture.width, parent._texture.height, parent.defaultFrameWitdh, parent.defaultFrameHeight);

        animations.push({
            name: "placeholder",
            loop: false,
            frames: [
                {
                    x: 0,
                    y: 0,
                    width: parent.defaultFrameWitdh,
                    height: parent.defaultFrameHeight,
                    name: "defaultFrame"
                }
            ],
            framerate: 24
        });
        playAnimation("placeholder");
    }

    private function generateFramesFromSheet(textureWidth:Float, textureHeight:Float, frameWidth:Float, frameHeight:Float) {
        var cols:Int = Std.int(textureWidth / frameWidth);
        var rows:Int = Std.int(textureHeight / frameHeight);
        var index:Int = 0;

        for (row in 0...rows) {
            var y:Float = row * frameHeight;
            if (y + frameHeight > textureHeight) break;

            for (col in 0...cols) {
                var x:Float = col * frameWidth;
                if (x + frameWidth > textureWidth) break;

                frames.push({
                    x: x,
                    y: y,
                    width: frameWidth,
                    height: frameHeight,
                    name: "frame_" + index
                });
                index++;
            }
        }
    }

    public function generateFromSparrow(xmlPath:String) {
        var xml:Xml = Xml.parse(Assets.getText(xmlPath));
        var data = new Access(xml.firstElement());

        for (sub in data.nodes.SubTexture) {
            var name:String = sub.att.name;
            var x:Float = Std.parseFloat(sub.att.x);
            var y:Float = Std.parseFloat(sub.att.y);
            var width:Float = Std.parseFloat(sub.att.width);
            var height:Float = Std.parseFloat(sub.att.height);
            var rotated:Bool = sub.has.rotated && sub.att.rotated == "true";

            var frameX:Float = sub.has.frameX ? Std.parseFloat(sub.att.frameX) : 0;
            var frameY:Float = sub.has.frameY ? Std.parseFloat(sub.att.frameY) : 0;
            var frameWidth:Float = sub.has.frameWidth ? Std.parseFloat(sub.att.frameWidth) : width;
            var frameHeight:Float = sub.has.frameHeight ? Std.parseFloat(sub.att.frameHeight) : height;

            frames.push({
                x: x,
                y: y,
                width: width,
                height: height,
                name: name,
                rotation: rotated ? -90 : 0,
                offsetY: frameY,
                offsetX: frameX
            });
        }

    }

    public function addAnimation(name:String, frames:Array<Int>, framerate:Int, loop:Bool = false) {
        var animation:Animation = {
            name: name,
            frames: [],
            framerate: framerate,
            loop: loop
        };
        
        for (i in frames){
            var pickedFrame:Null<Frame> = Lambda.find(this.frames, (f:Frame) -> {f.name == "frame_" + i;});
            if (pickedFrame == null){
                trace("Inexisten frame: " + i);
                break;
            }
            animation.frames.push(pickedFrame);
        }
        animations.push(animation);
    }

    public function addAnimationByPrefix(name:String, prefix:String, framerate:Int, loop:Bool = false) {
        var animFrames:Array<Frame> = frames.filter(f -> StringTools.startsWith(f.name, prefix));
        animFrames.sort((a, b) -> Reflect.compare(a.name, b.name)); 
        animations.push({
            name: name, 
            frames: animFrames,
            framerate: framerate,
            loop: loop
        });
    }

    public function addAnimationByIndices(name:String, prefix:String, indices:Array<Int>, framerate:Int, loop:Bool = false) {
        var animFrames:Array<Frame> = [];
        for (i in indices) {
            var fname = prefix + StringTools.lpad(Std.string(i), "0", 4); 
            var found = Lambda.find(frames, f -> f.name.indexOf(fname) != -1);
            if (found != null) animFrames.push(found);
        }
        animations.push({
            name: name, 
            frames: animFrames,
            framerate: framerate,
            loop: loop
        });
    }


    public function playAnimation(name:String) {
        var nextAnimation:Animation = Lambda.find(animations, a -> a.name == name);
        if (nextAnimation == null) nextAnimation = Lambda.find(animations, a -> a.name == "placeholder");
        currentAnimation = nextAnimation;
        currentIndex = 0;
        currentFrame = currentAnimation.frames[0];
        stopped = false;
    }

    public function update(dt:Float) {
        if (!stopped)
            currentIndex += dt * currentAnimation.framerate;

        if (currentIndex >= currentAnimation.frames.length) {
            if (currentAnimation.loop)
                currentIndex = 0;
            else {
                stopped = true;
                currentIndex = currentAnimation.frames.length - 1;
            }
        }

        currentFrame = currentAnimation.frames[Math.floor(currentIndex)];
    }

    public function render() {
        if (currentFrame == null) return;

        var transform:TransformComponent = parent.parent.hasComponent(TransformComponent) 
        ? parent.parent.getComponent(TransformComponent) 
        : new TransformComponent(parent.parent);

        var width:Float = currentFrame.width;
        var height:Float = currentFrame.height;

        var model:Matrix4 = new Matrix4();
        model.identity();

        model.appendTranslation(-width / 2, -height / 2, 0);
        model.appendScale(transform.scale.x, transform.scale.y, 1);
        model.appendRotation(currentFrame.rotation ?? 0, new Vector4(0, 0, 1, 0));
        model.appendRotation(transform.angle, new Vector4(0, 0, 1, 0));
        model.appendTranslation(width / 2, height / 2, 0);
        model.appendTranslation(transform.x, transform.y, 0);
        model.appendTranslation(-currentFrame.offsetX ?? 0, -currentFrame.offsetY ?? 0, 0);

        @:privateAccess
        Renderer.drawSprite(
            parent._texture,
            model,
            currentFrame.width,
            currentFrame.height,
            currentFrame.x,
            currentFrame.y,
            currentFrame.width,
            currentFrame.height
        );
    }
}
