package engine;

import kha.math.FastMatrix4;
import kha.graphics4.TextureUnit;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.Image;
import kha.graphics4.Usage;
import kha.math.FastVector4;

// TODO Instanced Rendering
class BatchRender {
	private var textureVertices: Map<Image, Array<Array<Float>>>;
	private var indexBuffer: IndexBuffer;
	private var textureID: TextureUnit;
	private var pipeline: Pipeline;
	private var vertexBuffer: VertexBuffer;
	private var camera: Camera;

	public function new(pipeline: Pipeline, camera: Camera) {
		textureVertices = new Map();
		this.indexBuffer = pipeline.indexBuffer;
		this.textureID = pipeline.state.getTextureUnit("myTextureSampler");
		this.pipeline = pipeline;
		this.camera = camera;
	}

	public function add(image: Image, vertices: Array<Float>) {
		if (textureVertices.get(image) == null)
			textureVertices.set(image, new Array<Array<Float>>());

		var vert = textureVertices.get(image);
		vert.push(vertices);
		textureVertices.set(image, vert);
	}

	public function render(g4: kha.graphics4.Graphics): Void {
		// still not working
		// return;

		// Instanced rendering
		if (!g4.instancedRenderingAvailable())
			return;

		for (image in textureVertices.keys()) {
			var vertices = textureVertices.get(image);
			if (vertices.length == 0)
				continue;

			var model = FastMatrix4.identity();
			model = model.multmat(camera.projection);
			model = model.multmat(camera.view);

			var instance: Int = 0;
			var buf = [];
			for (v in vertices) {
				if (v.length == 0)
					continue;

				var vertexBuffer = new VertexBuffer(v.length, pipeline.structure, Usage.StaticUsage, instance);
				var vbData = vertexBuffer.lock();
				for (i in 0...v.length) {
					vbData.set(i, v[i]);
				}
				vertexBuffer.unlock();
				instance++;
				buf.push(vertexBuffer);
			}

			// should remove matrix and create buffers
			g4.setMatrix(pipeline.state.getConstantLocation("MVP"), model);
			g4.setTexture(textureID, image);
			g4.setVertexBuffers(buf);
			g4.setIndexBuffer(indexBuffer);
			g4.drawIndexedVerticesInstanced(instance, 0, indexBuffer.count());
			textureVertices.set(image, new Array<Array<Float>>());
		}
	};
}
