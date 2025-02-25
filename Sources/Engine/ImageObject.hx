package engine;

import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.TextureUnit;
import kha.Image;

class ImageObject extends DisplayObject implements IDrawable {
	private var image: Image;
	private var textureID: TextureUnit;

	public function new(x: Float, y: Float, width: Float, height: Float, image: Image, camera: Camera, pipeline: Pipeline) {
		textureID = pipeline.state.getTextureUnit("myTextureSampler");
		this.image = image;
		super(x, y, width, height, camera, pipeline);
	}

	override public function render(g4: kha.graphics4.Graphics, batch: BatchRender): Void {
		if (!isActive)
			return;

		for (child in children)
			child.render(g4, batch);

		if (!isVisible)
			return;

		// batch.add(image, vertexBuffer);

		g4.setTexture(textureID, image);
		g4.setMatrix(mvpID, model);
		g4.setVertexBuffer(vertexBuffer);
		g4.setIndexBuffer(indexBuffer);
		g4.drawIndexedVertices(0, indexBuffer.count());
	};

	override public function update(currentTime: Float): Void {
		super.update(currentTime);
	}
}
