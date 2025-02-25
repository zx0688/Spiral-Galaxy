package engine;

import kha.Image;

class BatchRender {
	private var textureVertices: Map<Image, Array<Float>>;

	public function new() {
		textureVertices = new Map();
	}

	public function add(image: Image, vertices: Array<Float>) {
		var vert = textureVertices.get(image);
		if (vert == null)
			textureVertices.set(image, vertices);
		else
			vert.concat(vertices);
	}

	public function render(g4: kha.graphics4.Graphics): Void {
		/*
			TODO
			there's should be grouping by a texture, but i don't know how to add an object's matrix to render pipeline
			maybe like that
				vector = new FastVector4(vertices[i], vertices[i + 1], vertices[i + 2], 0)
				transformedVertices = model.multvec(vector);
				new VertexBuffer(transformedVertices);
			then we can remove setMatrix() at all

			for (textureVertix in textureVertices.keys) {
				g4.setTexture(textureID, textureVertix);
				g4.setVertexBuffer(textureVertices.get(textureVertix));
				g4.setIndexBuffer(indexBuffer);
				g4.setMatrix3(model)
				g4.drawIndexedVertices(0, indexBuffer.count());
		}*/
	};
}
