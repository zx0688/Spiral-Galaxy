import kha.graphics4.Graphics;
import kha.Assets;
import engine.ImageObject;

class Star extends ImageObject {
	public var mass: Float;

	public function new(x: Float, y: Float, radius: Float, mass: Float, camera: Camera, pipeline: Pipeline) {
		this.mass = mass;
		var image = Assets.images.simple2;
		super(x, y, radius, radius, image, camera, pipeline);

		// emulate 3D star field
		// z = Main.random.GetFloatIn(0, 30);
	}
}
