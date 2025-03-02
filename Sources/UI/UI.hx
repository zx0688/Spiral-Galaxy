package ui;

import engine.InstancedRender;
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
	var instRender: InstancedRender;

	var infoPanel: InfoPanel;
	var add1kStarsButton: Button;
	var add10kStarsButton: Button;

	public function new(space: Scene, settings: Dynamic, render: InstancedRender) {
		this.space = space;
		this.frameCount = 0;
		this.instRender = render;
		seed = Std.string(Reflect.field(settings, "seed"));

		infoPanel = new InfoPanel(0, 0);

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
		infoPanel.addText('FPS: ${this.fps}');
		infoPanel.addText('STARS: ${GalaxyFactory.allStarsInGalaxy.length}');
		infoPanel.addText('SEED:${seed}');
		infoPanel.addText('Frustum Call: ${instRender.objectCalledCount}');
		infoPanel.addText('DrawCall: ${instRender.drawCallCount}');
		infoPanel.addText('CONTROL Keyboard: <, >, v, ^, w, s');
		infoPanel.addText('CONTROL Mouse: drag and drop, wheel');

		infoPanel.render(g);

		// buttons
		add10kStarsButton.y = infoPanel.height + 20;
		add10kStarsButton.render(g);
		add1kStarsButton.y = add10kStarsButton.y + add10kStarsButton.height + 20;
		add1kStarsButton.render(g);

		frameCount++;
	}
}
