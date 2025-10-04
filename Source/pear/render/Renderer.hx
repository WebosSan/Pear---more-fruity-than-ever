package pear.render;

import pear.render.batchs.SpriteBatch;
import pear.system.AssetsBackend;
import pear.core.PearEngine;
import lime.math.Matrix4;
import pear.render.batchs.RectBatch;

class Renderer {
	private static var _initialized:Bool = false;

	private static var _spriteBatch:SpriteBatch;
	private static var _rectBatch:RectBatch;

	@:noCompletion public static function init() {
		if (_initialized)
			return;
		_initialized = true;

		AssetsBackend.init();

		PearEngine.gl.blendFunc(PearEngine.gl.SRC_ALPHA, PearEngine.gl.ONE_MINUS_SRC_ALPHA);
		PearEngine.gl.enable(PearEngine.gl.BLEND);

		#if desktop
		PearEngine.gl.enable(PearEngine.gl.TEXTURE_2D);
		#end

		_rectBatch = new RectBatch();
		_spriteBatch = new SpriteBatch();
	}

	public static function drawSprite(texture:Texture, ?matrix:Matrix4, ?targetWidth:Float, ?targetHeight:Float, ?sourceX:Float = 0, ?sourceY:Float = 0, ?sourceWidth:Float = -1, ?sourceHeight:Float = -1) {
		_spriteBatch.drawSprite(texture, matrix, targetWidth, targetHeight, sourceX, sourceY, sourceWidth, sourceHeight);
	}

	public static function drawRectOutline(width:Float, height:Float, color:Int, thickness:Float = 1, ?matrix:Matrix4) {
		var r = ((color >> 16) & 0xFF) / 0xFF;
		var g = ((color >> 8) & 0xFF) / 0xFF;
		var b = (color & 0xFF) / 0xFF;
		var a = ((color >> 24) & 0xFF) / 0xFF;

		_rectBatch.drawOutline(width, height, [r, g, b, a], thickness, matrix);
	}

	public static function fillRect(width:Float, height:Float, color:Int, ?matrix:Matrix4) {
		var r = ((color >> 16) & 0xFF) / 0xFF;
		var g = ((color >> 8) & 0xFF) / 0xFF;
		var b = (color & 0xFF) / 0xFF;
		var a = ((color >> 24) & 0xFF) / 0xFF;

		_rectBatch.draw(width, height, [r, g, b, a], matrix);
	}

	@:noCompletion public static function destroy() {
		_rectBatch.destroy();
	}
}
