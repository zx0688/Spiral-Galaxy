package engine;

import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.TextureUnit;
import kha.Image;

class ImageObject extends DisplayObject implements IDrawable {
	private var image: Image;
	private var textureID: TextureUnit;

	public function new(x: Float, y: Float, width: Float, height: Float, image: Image, camera: Camera) {
		textureID = Pipeline.getInstance().pipeline.getTextureUnit("myTextureSampler");
		this.image = image;
		super(x, y, width, height, camera);
	}

	override public function render(g4: kha.graphics4.Graphics): Void {
		for (child in children)
			child.render(g4);

		g4.setTexture(textureID, image);
		super.render(g4);
	};
}
