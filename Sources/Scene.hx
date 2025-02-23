package;

import kha.Assets;
import kha.System;
import engine.ImageObject;

class Scene extends ImageObject {
	public function new() {
		var camera = new Camera();
		var space = Assets.images.simple;

		super(0, 0, System.windowWidth(0), System.windowHeight(0), space, camera);

		kha.input.Mouse.get().notify(null, null, null, onMouseWheel);
	}

	public function init(): Scene {
		for (i in 0...30000)
			addChild(new ImageObject((Math.random() - 0.5) * 1000, (Math.random() - 0.5) * 1000, 10, 10, Assets.images.simple2, camera));

		return this;
	}

	function onMouseWheel(delta: Int) {
		camera.distance += delta * 1;
	}
}
