package engine;

import utils.DynamicImageFactory;
import kha.math.FastVector2;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.TextureUnit;
import kha.Image;
import engine.InstancedRender;

class ImageObject extends DisplayObject implements IUpdatable {
	private var image: Image;
	private var textureID: TextureUnit;

	public function new(x: Float, y: Float, width: Float, height: Float, image: Image, camera: Camera, pipeline: Pipeline) {
		textureID = pipeline.state.getTextureUnit("utexture");
		this.image = image;
		super(x, y, width, height, camera, pipeline);
	}

	override public function render(g4: kha.graphics4.Graphics, batch: InstancedRender): Void {
		if (!isActive)
			return;

		for (child in children)
			child.render(g4, batch);

		if (!isVisible)
			return;

		batch.add(image, {
			position: viewPosition,
			size: viewSize,
			angle: 0
		});
	}
}
