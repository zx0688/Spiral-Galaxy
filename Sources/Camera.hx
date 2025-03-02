package;

import engine.IResizable;
import kha.math.FastVector2;
import kha.math.FastVector4;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.System;

class Camera implements IResizable {
	public static inline var MAX_DISTANCE: Int = 100;
	public static inline var ANGLE_PERSPECTIVE: Float = 45.0;
	public static inline var BASE_RESOLUTION_WIDTH: Int = 1000;
	public static inline var BASE_RESOLUTION_HEIGHT: Int = 1000;

	public var projection: FastMatrix4;
	public var view: FastMatrix4;

	// scope of view x, y, width, height
	public var scope: FastVector4;

	@:isVar public var position(get, set): FastVector2 = new FastVector2(0, 0);

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

		value = value > MAX_DISTANCE ? MAX_DISTANCE : value;
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
		var glob = ConvertPerspectivePointToGlobalPoint(position.x, position.y);

		scope.x = glob.x;
		scope.y = glob.y;
		scope.z = size.x * 1.1;
		scope.w = size.y * 1.1;
	}

	public function new() {
		scope = new FastVector4(0, 0, 0, 0);

		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);

		// look at the scene from the top
		distance = MAX_DISTANCE;
		position = new FastVector2(0, 0);
	}

	public function resize() {
		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);
		updateView();
	}

	public static function ConvertPointByPerspective(_x: Float, _y: Float, _distance1: Float, _distance2: Float): FastVector2 {
		var x = (_distance2 / _distance1) * _x;
		var y = (_distance2 / _distance1) * _y;
		return new FastVector2(x, y);
	}

	public static function ConvertPerspectivePointToGlobalPoint(_x: Float, _y: Float): FastVector2 {
		var tan: Float = 0.4142;
		var sw = BASE_RESOLUTION_WIDTH;
		var sh = BASE_RESOLUTION_HEIGHT;
		var aspectRatio = sw / sh;

		var h = 2 * MAX_DISTANCE * tan;
		var w = h * aspectRatio;

		var scaleFactor: Float = 0.68;

		var xn = _x / (w * scaleFactor);
		var yn = _y / (h * scaleFactor);

		var x = xn * sw;
		var y = yn * sh;

		return new FastVector2(x, y);
	}

	public static function ConvertGlobalPointToPerspectivePoint(_x: Float, _y: Float): FastVector2 {
		var tan: Float = 0.4142;
		var sw = BASE_RESOLUTION_WIDTH;
		var sh = BASE_RESOLUTION_HEIGHT;
		var aspectRation = sw / sh;
		var h = 2 * MAX_DISTANCE * tan;
		var w = h * aspectRation;

		var xn = (_x / sw) * 0.68;
		var yn = (_y / sh) * 0.68;
		var x = xn * w;
		var y = yn * h;

		return new FastVector2(x, y);
	}
}
