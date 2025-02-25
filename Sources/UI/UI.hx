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

	var add1kStarsButton: Button;
	var add10kStarsButton: Button;

	public function new(space: Scene, settings: Dynamic) {
		this.space = space;
		this.frameCount = 0;
		seed = Std.string(Reflect.field(settings, "seed"));

		add10kStarsButton = new Button(10, 70, 110, 30, Color.Yellow, "+10000", () -> {
			space.generateNewStars(10000);
		});
		add1kStarsButton = new Button(10, 120, 110, 30, Color.Yellow, "+1000", () -> {
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
		g.fillRect(0, 0, 400, 27);
		g.color = Color.Green;
		g.font = Assets.fonts.RussoOne_Regular;
		g.fontSize = 30;
		final info = 'FPS: ${this.fps} STARS: ${GalaxyFactory.allStarsInGalaxy.length} SEED:${seed}';
		g.drawString(info, 0, 0);
		g.color = Color.Black;
		g.fillRect(0, 25, 800, 27);
		g.color = Color.Magenta;
		final control = 'CONTROL Keyboard: <, >, v, ^, w, s   Mouse: drag and drop, wheel';
		g.drawString(control, 0, 25);

		// buttons
		add10kStarsButton.render(g);
		add1kStarsButton.render(g);

		frameCount++;
	}
}
