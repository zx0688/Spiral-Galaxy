package ui;

import utils.GalaxyFactory;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;

class UI {
	var frameCount: Int;
	var fps: Int;
	var space: Scene;
	var seed: String;

	var add1000Button: Button;
	var add10000Button: Button;

	public function new(space: Scene, settings: Dynamic) {
		this.space = space;
		this.frameCount = 0;
		seed = Std.string(Reflect.field(settings, "seed"));

		add10000Button = new Button(10, 50, 100, 30, Color.Yellow, "+10000", () -> {
			space.generateNewStars(10000);
		});
		add1000Button = new Button(10, 90, 100, 30, Color.Yellow, "+1000", () -> {
			space.generateNewStars(1000);
		});

		Scheduler.addTimeTask(fpsCount, 0, 1);
	}

	public function fpsCount() {
		fps = frameCount;
		frameCount = 0;
	}

	public function render(g: kha.graphics2.Graphics) {
		// texts
		g.color = Color.Black;
		g.fillRect(0, 0, 300, 22);
		g.color = Color.Green;
		g.font = Assets.fonts.RussoOne_Regular;
		g.fontSize = 22;
		final info = 'FPS: ${this.fps} STARS: ${GalaxyFactory.allStarsInGalaxy.length} SEED:${seed}';
		g.drawString(info, 0, 0);
		g.color = Color.Black;
		g.fillRect(0, System.windowHeight(0) - 25, 600, 22);
		g.color = Color.Magenta;
		final control = 'CONTROL Keyboard: <, >, v, ^, w, s   Mouse: drag and drop, wheel';
		g.drawString(control, 0, System.windowHeight(0) - 25);

		// buttons
		add10000Button.render(g);
		add1000Button.render(g);

		frameCount++;
	}
}
