import kha.Scheduler;
import kha.Assets;
import kha.Color;
import kha.graphics4.Graphics;
import kha.System;
import engine.DisplayObject;

class Preloader extends DisplayObject {
	private var progressBar: DisplayObject;
	private var timeTaskId: Int;

	public function new(pipeline: Pipeline) {
		var camera = new Camera();
		super(0, 0, System.windowWidth(0), System.windowHeight(0), camera, pipeline);

		progressBar = addChild(new DisplayObject(0, 0, System.windowWidth(0), 20, camera, pipeline));
		progressBar.width = 0;
	}

	public function start(callback: Void->Void): Preloader {
		Assets.loadEverything(() -> {
			init();
			callback();
			Scheduler.removeTimeTask(timeTaskId);
			isVisible = false;
		});

		timeTaskId = Scheduler.addTimeTask(() -> {
			this.progressBar.width = System.windowWidth(0) * Assets.progress;
		}, 0, 1 / 60);

		return this;
	}

	function init() {
		// some
	}
}
