package pear.components;

import pear.system.CacheBackend;
import lime.math.Vector4;
import lime.math.Matrix4;
import pear.render.Texture;

class SpriteComponent extends Component {
	public var width:Float;
	public var height:Float;

	public var flipX:Bool = false;
	public var flipY:Bool = false;

	public var color:Int = 0xFFFFFFFF;

	public var path(default, set):String;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;

	private var _texture:Texture;

	public function new(parent:Entity, path:String) {
		super(parent);
		this.path = path;

		this.width = _texture.width;
		this.height = _texture.height;
	}

	override function render() {
		super.render();
		var transform:TransformComponent = parent.hasComponent(TransformComponent) ? parent.getComponent(TransformComponent) : new TransformComponent(parent);

		var model:Matrix4 = new Matrix4();
		model.identity();

		model.appendTranslation(-width / 2, -height / 2, 0);
		model.appendScale(transform.scale.x, transform.scale.y, 1);
		model.appendRotation(transform.angle, new Vector4(0, 0, 1, 0));
		model.appendTranslation(width / 2, height / 2, 0);
		model.appendTranslation(transform.x + offsetX, transform.y + offsetY, 0);

		//Renderer.drawSprite(_texture, model, width * transform.scale.x, height * transform.scale.y, 0, 0, -1, -1, flipX, flipY, color);
	}

	private function set_path(v:String):String {
		if (_texture != null)
			_texture.destroy();
		_texture = CacheBackend.getTexture(v);
		return path = v;
	}
}
