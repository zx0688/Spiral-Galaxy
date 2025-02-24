import haxe.Json;
import ui.UI;
import kha.System;
import kha.Framebuffer;
import kha.Color;
import kha.Assets;
import kha.Scheduler;
import kha.Image;
import kha.math.Random;

class Main {
	public static var random: Random;

	static var pipeline: Pipeline;
	static var space: Scene;
	static var preloader: Preloader;
	static var settings: Dynamic;
	static var backbuffer: Image;
	static var fps: Int = 0;

	static var ui: UI;

	public static function main() {
		System.start({title: "Spiral Galaxy", width: 1040, height: 680}, function loadAssets(_) {
			pipeline = new Pipeline();
			preloader = new Preloader(pipeline).start(init);
		});
	}

	static function init() {
		settings = Json.parse(Reflect.field(Assets.blobs, "settings_json").toString());
		random = new Random(Reflect.field(settings, "seed"));

		space = new Scene(pipeline, settings).init();
		ui = new UI(space, settings);

		Scheduler.addTimeTask(update, 0, 1 / 30);
		System.notifyOnFrames(render);
	}

	static public function update() {
		space.update(Scheduler.time());
	}

	static function render(frames: Array<Framebuffer>) {
		// main scene
		var g4 = frames[0].g4;
		g4.begin();
		g4.clear(Color.Black);
		g4.setPipeline(pipeline.state);
		preloader.render(g4);
		space.render(g4);
		g4.end();

		// ui
		var g2 = frames[0].g2;
		g2.begin(false);
		ui.render(g2);
		g2.end();
	}
}
