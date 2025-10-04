package pear.animations;

typedef Frame = {
    var x:Float;
    var y:Float;

    var width:Float;
    var height:Float;

    var name:String;

    @:optional var rotation:Float;

    @:optional var offsetX:Float;
    @:optional var offsetY:Float;
}
