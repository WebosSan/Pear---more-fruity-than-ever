package pear.utils.core;

import pear.Entity;
import Type;

abstract NextTarget(Void -> Entity) from Void -> Entity to Void -> Entity {

    @:from
    public static function fromScene(scene:Entity):NextTarget {
        return () -> scene;
    }

    @:from
    public static function fromMaker(scene:Void -> Entity):NextTarget {
        return scene;
    }

    @:from
    public static function fromClass(scene:Class<Entity>):NextTarget {
        return () -> Type.createInstance(scene, []);
    }
}
