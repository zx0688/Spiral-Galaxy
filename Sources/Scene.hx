package;

import kha.Scheduler;
import kha.math.FastVector2;
import kha.input.KeyCode;
import kha.Assets;
import kha.System;
import engine.ImageObject;
import utils.GalaxyFactory;

class Scene extends ImageObject {
	public var settings: Dynamic;
	// smooth changind
	public var targetPosition: FastVector2;
	public var targetDistance: Float;
	public var lerpSpeed: Float = 0.12;

	// mouse drag and drop
	var isMouseDown: Bool;
	var mouseX = 0.0;
	var mouseY = 0.0;
	var mouseDeltaX = 0.0;
	var mouseDeltaY = 0.0;
	var mouseSpeed: Float = 4;
	var mouseWheel: Float = 4;

	// keyboard
	var up: Bool;
	var down: Bool;
	var left: Bool;
	var right: Bool;
	var w: Bool;
	var s: Bool;
	var keyboardSpeed: Float = 2;

	var lastCameraDistance: Float;

	public function new(pipeline: Pipeline, settings: Dynamic, camera: Camera) {
		this.settings = settings;
		this.camera = camera;

		var space = Assets.images.galaxy;

		super(0, 0, System.windowWidth(0), System.windowHeight(0), space, camera, pipeline);

		kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
		kha.input.Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	public function init(): Scene {
		targetDistance = camera.distance;
		targetPosition = new FastVector2(camera.position.x, camera.position.y);
		lastCameraDistance = camera.distance;

		generateNewStars(Reflect.field(settings, "starCount"));

		return this;
	}

	public function generateNewStars(count: Int): Void {
		var newStars = GalaxyFactory.generateNewSpiralStar(count, 1000, cast Reflect.field(settings, "typeStars"), camera, pipeline, settings);
		for (star in newStars) {
			addChild(star);
		}
	}

	override public function update(currentTime: Float) {
		mouseSpeed = Camera.ConvertPointByPerspective(4, 0, Camera.MAX_DISTANCE, camera.distance).x;

		// update camera position
		var position = camera.position;

		if (isMouseDown) {
			targetPosition.x = position.x + mouseSpeed * mouseDeltaX * -1;
			targetPosition.y = position.y + mouseSpeed * mouseDeltaY;
		}

		if (left)
			targetPosition.x -= keyboardSpeed;
		if (right)
			targetPosition.x += keyboardSpeed;
		if (up)
			targetPosition.y += keyboardSpeed;
		if (down)
			targetPosition.y -= keyboardSpeed;

		position.x = lerp(position.x, targetPosition.x, lerpSpeed);
		position.y = lerp(position.y, targetPosition.y, lerpSpeed);
		camera.position = position;

		if (w)
			targetDistance -= mouseWheel;
		if (s)
			targetDistance += mouseWheel;

		if (targetDistance < 1)
			targetDistance = 1;
		else if (targetDistance > 99.9)
			targetDistance = 99.9;

		camera.distance = lerp(camera.distance, targetDistance, lerpSpeed);

		mouseDeltaX = 0;
		mouseDeltaY = 0;

		super.update(currentTime);
	}

	override function resize() {
		camera.resize();
		super.resize();
	}

	function onKeyDown(key: Int) {
		if (key == KeyCode.Up)
			up = true;
		else if (key == KeyCode.Down)
			down = true;
		else if (key == KeyCode.Left)
			left = true;
		else if (key == KeyCode.Right)
			right = true;
		else if (key == KeyCode.W)
			w = true;
		else if (key == KeyCode.S)
			s = true;
	}

	function onKeyUp(key: Int) {
		if (key == KeyCode.Up)
			up = false;
		else if (key == KeyCode.Down)
			down = false;
		else if (key == KeyCode.Left)
			left = false;
		else if (key == KeyCode.Right)
			right = false;
		else if (key == KeyCode.W)
			w = false;
		else if (key == KeyCode.S)
			s = false;
	}

	function onMouseDown(button: Int, x: Int, y: Int) {
		isMouseDown = true;
	}

	function onMouseUp(button: Int, x: Int, y: Int) {
		isMouseDown = false;
	}

	function onMouseWheel(delta: Int) {
		targetDistance += delta * mouseWheel;
	}

	function onMouseMove(x: Int, y: Int, movementX: Int, movementY: Int) {
		mouseDeltaX = x - mouseX;
		mouseDeltaY = y - mouseY;

		mouseX = x;
		mouseY = y;
	}

	function lerp(start: Float, end: Float, t: Float): Float {
		return start + (end - start) * t;
	}
}
