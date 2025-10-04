package;

import pear.core.PearEngine;
import lime.app.Application;

class Main extends Application {
    override function onWindowCreate() {
        super.onWindowCreate();
		new PearEngine(this, TestWorld);
    }
}
