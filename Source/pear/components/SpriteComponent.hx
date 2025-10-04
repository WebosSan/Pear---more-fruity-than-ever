package pear.components;

import pear.system.AssetsBackend;
import lime.math.Vector4;
import lime.math.Matrix4;
import pear.render.Renderer;
import pear.render.Texture;

class SpriteComponent extends Component {
	public var width:Float;
	public var height:Float;

	public var path(default, set):String;

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
		model.appendTranslation(transform.x, transform.y, 0);

		Renderer.drawSprite(_texture, model, width, height);
	}

	private function set_path(v:String):String {
		if (_texture != null)
			_texture.destroy();
		_texture = AssetsBackend.getTexture(v);
		return path = v;
	}
}
