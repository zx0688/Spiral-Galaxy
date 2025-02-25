package;

import engine.IResizable;
import kha.math.FastVector4;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.System;
import kha.math.Vector2;

class Camera implements IResizable {
	public static inline var MAX_DISTANCE: Int = 100;
	public static inline var ANGLE_PERSPECTIVE: Float = 45.0;

	public var projection: FastMatrix4;
	public var view: FastMatrix4;

	// scope of view x, y, width, height
	public var scope: FastVector4;

	@:isVar public var position(get, set): Vector2 = new Vector2(0, 0);

	function get_position() {
		return this.position;
	}

	function set_position(value) {
		this.position = value;
		updateView();
		scopeUpdate();
		return value;
	}

	@:isVar public var distance(get, set): Float;

	function get_distance() {
		return this.distance;
	}

	function set_distance(value) {
		if (value == this.distance)
			return value;

		value = value > 99 ? 99 : value;
		value = value < 1 ? 1 : value;
		this.distance = value;
		updateView();
		scopeUpdate();
		return value;
	}

	function updateView() {
		view = FastMatrix4.lookAt(new FastVector3(this.position.x, this.position.y, this.distance), new FastVector3(this.position.x, this.position.y, 0),
			new FastVector3(0, 1, 0));
	}

	// for frustum culling
	function scopeUpdate() {
		var size = ConvertPointByPerspective(System.windowWidth(0), System.windowHeight(0), MAX_DISTANCE, this.distance);
		var position = ConvertPerspectivePointToGlovalPoint(this.position.x, this.position.y, MAX_DISTANCE);

		scope.x = position.x;
		scope.y = position.y;
		scope.z = size.x;
		scope.w = size.y;
	}

	public function new() {
		scope = new FastVector4(0, 0, 0, 0);
		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);

		// look at the scene from the top
		distance = MAX_DISTANCE - 1;
		position = new Vector2(0, 0);
	}

	public function resize() {
		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);
		updateView();
	}

	public static function ConvertPointByPerspective(_x: Float, _y: Float, _distance1: Float, _distance2: Float): Vector2 {
		var x = (_distance2 / _distance1) * _x;
		var y = (_distance2 / _distance1) * _y;
		return new Vector2(x, y);
	}

	public static function ConvertPerspectivePointToGlovalPoint(_x: Float, _y: Float, _distance: Float = MAX_DISTANCE): Vector2 {
		var tan: Float = 0.41421112; // Math.tan(ANGLE_PERSPECTIVE * 0.0087266);
		var aspectRatio = System.windowWidth(0) / System.windowHeight(0);
		var x = (_x * System.windowHeight(0)) / (_distance * aspectRatio * tan);
		var y = (_y * System.windowWidth(0)) / (_distance * aspectRatio * tan * aspectRatio);
		return new Vector2(x, y);
	}

	public static function ConvertGlobalPointToPerspectivePoint(_x: Float, _y: Float, _distance: Float = MAX_DISTANCE): Vector2 {
		var tan: Float = 0.41421112; // Math.tan(ANGLE_PERSPECTIVE * 0.0087266);
		var aspectRatio = System.windowWidth(0) / System.windowHeight(0);
		var x = (_distance * aspectRatio * tan * _x) / System.windowHeight(0);
		var y = (_distance * aspectRatio * tan * aspectRatio * _y) / System.windowWidth(0);
		return new Vector2(x, y);
	}

	public static function GenerateVertixForImageGlobalSize(_width: Float, _height: Float): Array<Float> {
		var pos = ConvertGlobalPointToPerspectivePoint(_width, _height);
		var height = pos.y;
		var width = pos.x;

		var vertices: Array<Float> = [
			-width, -height, 0.0, 0.0, 1.0, width, -height, 0.0, 1.0, 1.0, width, height, 0.0, 1.0, 0.0, -width, height, 0.0, 0.0, 0.0, 0.0
		];
		return vertices;
	}
}
