import kha.graphics4.Graphics;
import components.SpriteRender.SpriteRenderer;
import simpleECS.*;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	private static var engine:Engine;

	public static function main() {
		Scheduler.addTimeTask(function() {
			// engine.update();
		}, 0, 1 / 60);

		System.start({
			title: "VolkaTest",
			width: 1920,
			height: 1080,
			framebuffer: {verticalSync: false}
		}, function(_) {
			kha.System.notifyOnFrames(render);
			Assets.loadEverything(function() {});
		});
	}

	static function render(framebuffer:Framebuffer) {
		var g:Graphics = framebuffer.g4;
		g.begin();
		g.fillRect(0, 0, kha.System.windowWidth(), kha.System.windowHeight(), 0x000000);
		g.end();
	}
}
