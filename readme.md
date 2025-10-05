# Pear Engine

Pear Engine is a lightweight 2D game engine built with **Lime** and **OpenGL**, designed for fast rendering, modular architecture, and smooth cross-platform development.

---

## Getting Started

To start using Pear Engine, initialize it in your Lime application right after creating the window.  
The constructor requires two parameters: your `Application` instance and the initial `Scene` class.

```haxe
package;


import pear.core.PearEngine;
import lime.app.Application;
import lime.graphics.RenderContext;


class Main extends Application {
	public function new () {
		super ();
	}	

	override function onWindowCreate() {
		super.onWindowCreate();
		new PearEngine(this, MainScene);
	}
}
```