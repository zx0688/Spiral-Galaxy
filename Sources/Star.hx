import kha.System;
import kha.math.FastMatrix4;
import utils.DynamicImageFactory;
import engine.ImageObject;

class Star extends ImageObject {
	public static inline var RED_GIGANT: Int = 30;
	public static inline var BLUE_GIGANT: Int = 35;
	public static inline var BROWN_DWARF: Int = 45;
	public static inline var WHITE_DWARF: Int = 100;

	public var mass: Float;
	public var type: String;

	@:isVar public var rotation(get, set): Float;

	function get_rotation() {
		return this.rotation;
	}

	function set_rotation(v) {
		this.rotation = v;
		return v;
	}

	public function new(x: Float, y: Float, rotation: Float, radius: Float, mass: Float, type: String, camera: Camera, pipeline: Pipeline) {
		this.mass = mass;
		this.type = type;

		this.image = DynamicImageFactory.getTexture(type, camera.distance, null);
		super(x, y, radius * 2, radius * 2, image, camera, pipeline);
		this.rotation = rotation;

		this.z = 0.1;

		// emulate 3D star field
		// z = Main.random.GetFloatIn(0, 50);
	}

	override function update(currentTime: Float) {
		this.image = DynamicImageFactory.getTexture(type, camera.distance, image);
		super.update(currentTime);
	}
}
