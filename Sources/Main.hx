import kha.graphics4.TextureUnit;
import kha.WindowOptions;
import kha.WindowMode;
import kha.Window;
import utils.DynamicImageFactory;
import engine.InstancedRender;
import haxe.Json;
import ui.UI;
import kha.System;
import kha.Framebuffer;
import kha.Color;
import kha.Assets;
import kha.Scheduler;
import kha.Image;
import kha.math.Random;
#if kha_html5
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import kha.Macros;
import js.html.FileReader;
import js.html.DragEvent;
import js.Browser;
#end

class Main {
	public static var random: Random;

	static var pipeline: Pipeline;
	static var space: Scene;
	static var preloader: Preloader;
	static var settings: Dynamic;
	static var backbuffer: Image;
	static var instancedRender: InstancedRender;
	static var fps: Int = 0;
	static var ui: UI;

	public static function main() {
		System.start({
			title: "Spiral Galaxy",
			width: 1280,
			height: 1024,
			window: {
				mode: WindowMode.Fullscreen
			}
		}, function loadAssets(_) {
			pipeline = new Pipeline();
			preloader = new Preloader(pipeline).start(init);
		});
	}

	static function init() {
		settings = Json.parse(Reflect.field(Assets.blobs, "settings_json").toString());
		random = new Random(Reflect.field(settings, "seed"));

		DynamicImageFactory.init();
		var camera: Camera = new Camera();
		space = new Scene(pipeline, settings, camera).init();
		instancedRender = new InstancedRender(pipeline, camera);
		ui = new UI(space, settings, instancedRender);

		Scheduler.addTimeTask(update, 0, 1 / 30);
		System.notifyOnFrames(render);

		#if kha_html5
		window.onresize = function() {
			Main.resize();
		}
		#end

		update();
	}

	static function resize() {
		space.resize();
	}

	static function update() {
		var time = Scheduler.time();
		space.update(time);
		instancedRender.update(time);
	}

	static function render(frames: Array<Framebuffer>) {
		// main scene
		var g4 = frames[0].g4;
		g4.begin();
		g4.clear(Color.Black);
		g4.setPipeline(pipeline.state);

		// collect view data into batch
		preloader.render(g4, instancedRender);
		space.render(g4, instancedRender);

		// draw
		instancedRender.render(g4, null);
		g4.end();

		// ui
		var g2 = frames[0].g2;
		g2.begin(false);
		ui.render(g2);
		g2.end();
	}
}
