package;

import kha.math.FastVector4;
import kha.math.Vector4;
import haxe.ds.Vector;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.System;
import kha.math.Vector2;

class Camera {
	public static inline var MAX_DISTANCE: Int = 100;
	public static inline var ANGLE_PERSPECTIVE: Float = 45.0;

	public var projection: FastMatrix4;
	public var view: FastMatrix4;
	public var rect: FastVector4;

	public var cameraUpdateEvent: Void->Void;

	@:isVar public var position(get, set): Vector2 = new Vector2(0, 0);

	function get_position() {
		return this.position;
	}

	function set_position(value) {
		view = FastMatrix4.lookAt(new FastVector3(value.x, value.y, distance), new FastVector3(value.x, value.y, 0), new FastVector3(0, 1, 0));
		this.position = value;
		rectUpdate();
		return value;
	}

	@:isVar public var distance(get, set): Float;

	function get_distance() {
		return this.distance;
	}

	function set_distance(value) {
		// if (value == this.distance)
		//		return value;
		value = value > 99 ? 99 : value;
		value = value < 1 ? 1 : value;
		this.distance = value;
		view = FastMatrix4.lookAt(new FastVector3(this.position.x, this.position.y, value), new FastVector3(this.position.x, this.position.y, 0),
			new FastVector3(0, 1, 0));
		rectUpdate();
		return value;
	}

	function rectUpdate() {
		var size = ConvertPointByPerspective(System.windowWidth(0), System.windowHeight(0), 100, this.distance);
		var position = ConvertPerspectivePointToGlovalPoint(this.position.x, this.position.y, 100);

		rect.x = position.x;
		rect.y = position.y;
		rect.z = size.x;
		rect.w = size.y;
	}

	public function new() {
		rect = new FastVector4(0, 0, 0, 0);
		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);

		// look at the scene from the top
		distance = MAX_DISTANCE - 1;
		position = new Vector2(0, 0);
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
			-width, -height, 0.0, 0.0, 1.0, width, -height, 0.0, 1.0, 1.0, width, height, 0.0, 1.0, 0.0, -width, height, 0.0, 0.0, 0.0
		];
		return vertices;
	}
}
