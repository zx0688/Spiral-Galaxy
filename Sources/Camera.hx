package;

import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.System;
import kha.math.Vector2;

class Camera {
	public static inline var MAX_DISTANCE: Int = 100;
	public static inline var ANGLE_PERSPECTIVE: Float = 45.0;

	public var projection: FastMatrix4;
	public var view: FastMatrix4;

	public var cameraUpdateEvent: Void->Void;

	@:isVar public var distance(get, set): Float;

	function get_distance() {
		return this.distance;
	}

	function set_distance(value) {
		value = value > 99 ? 99 : value;
		value = value < 1 ? 1 : value;
		this.distance = value;
		view = FastMatrix4.lookAt(new FastVector3(0, 0, value), new FastVector3(0, 0, 0), new FastVector3(0, 1, 0));
		return value;
	}

	public function new() {
		projection = FastMatrix4.perspectiveProjection(ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, MAX_DISTANCE);

		// look at the scene from the top
		distance = MAX_DISTANCE - 1;
	}

	public static function ConvertGlobalPointToPerspective(_x: Float, _y: Float): Vector2 {
		var tan = Math.tan(ANGLE_PERSPECTIVE * 0.0087266);
		var aspectRatio = System.windowWidth(0) / System.windowHeight(0);
		var x = (MAX_DISTANCE * aspectRatio * tan * _x) / System.windowHeight(0);
		var y = (MAX_DISTANCE * aspectRatio * tan * aspectRatio * _y) / System.windowWidth(0);
		return new Vector2(x, y);
	}

	public static function GenerateVertixForImageGlobalSize(_width: Float, _height: Float): Array<Float> {
		var pos = ConvertGlobalPointToPerspective(_width, _height);
		var height = pos.y;
		var width = pos.x;
		var vertices: Array<Float> = [
			-width, -height, 0.0, 0.0, 1.0, width, -height, 0.0, 1.0, 1.0, width, height, 0.0, 1.0, 0.0, -width, height, 0.0, 0.0, 0.0
		];
		return vertices;
	}
}
