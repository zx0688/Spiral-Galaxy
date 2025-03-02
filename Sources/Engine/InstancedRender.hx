package engine;

import kha.math.FastVector2;
import kha.math.FastMatrix3;
import kha.math.Matrix4;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.graphics4.TextureUnit;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.Image;
import kha.graphics4.Usage;
import kha.math.FastVector4;
import Math;

typedef ObjectViewData = {
	var position: FastVector3;
	var size: FastVector2;
	var angle: Float;
}

// Instanced Rendering
class InstancedRender implements IDrawable implements IUpdatable {
	private var textureViewData: Map<Image, Array<ObjectViewData>>;
	private var textureID: TextureUnit;
	private var pipeline: Pipeline;
	private var view: FastMatrix4;
	private var camera: Camera;

	@:isVar public var drawCallCount(get, default): Int;

	function get_drawCallCount(): Int {
		return this.drawCallCount;
	}

	@:isVar public var objectCalledCount(get, default): Int;

	function get_objectCalledCount(): Int {
		return this.objectCalledCount;
	}

	public function new(pipeline: Pipeline, camera: Camera) {
		textureViewData = new Map();
		this.textureID = pipeline.state.getTextureUnit("utexture");
		this.pipeline = pipeline;
		this.view = FastMatrix4.identity();
		this.camera = camera;
	}

	public function add(image: Image, data: ObjectViewData) {
		if (textureViewData.get(image) == null)
			textureViewData.set(image, new Array<ObjectViewData>());
		var vd = textureViewData.get(image);
		vd.push(data);
		textureViewData.set(image, vd);
	}

	public function update(currentTime: Float): Void {
		view = FastMatrix4.identity();
		view = view.multmat(camera.projection);
		view = view.multmat(camera.view);
	}

	public function render(g4: kha.graphics4.Graphics, batch: InstancedRender): Void {
		var indexBuffer = pipeline.indexBuffer;
		drawCallCount = 0;
		objectCalledCount = 0;

		for (image in textureViewData.keys()) {
			var dataView: Array<ObjectViewData> = textureViewData.get(image);
			if (dataView.length == 0)
				continue;

			objectCalledCount += dataView.length;
			var buffs = [pipeline.vertexBuffer];

			// second buffer for model
			var vertexBuffer2 = new VertexBuffer(dataView.length, pipeline.structureModel, Usage.StaticUsage, 1);
			var mData = vertexBuffer2.lock();
			for (i in 0...dataView.length) {
				var pos = dataView[i].position;

				// apply position and size
				var mvp = view.multmat(FastMatrix4.translation(pos.x, pos.y, pos.z));
				mvp = mvp.multmat(FastMatrix4.scale(dataView[i].size.x, dataView[i].size.y, 1));

				mData.set(i * 16 + 0, mvp._00);
				mData.set(i * 16 + 1, mvp._01);
				mData.set(i * 16 + 2, mvp._02);
				mData.set(i * 16 + 3, mvp._03);

				mData.set(i * 16 + 4, mvp._10);
				mData.set(i * 16 + 5, mvp._11);
				mData.set(i * 16 + 6, mvp._12);
				mData.set(i * 16 + 7, mvp._13);

				mData.set(i * 16 + 8, mvp._20);
				mData.set(i * 16 + 9, mvp._21);
				mData.set(i * 16 + 10, mvp._22);
				mData.set(i * 16 + 11, mvp._23);

				mData.set(i * 16 + 12, mvp._30);
				mData.set(i * 16 + 13, mvp._31);
				mData.set(i * 16 + 14, mvp._32);
				mData.set(i * 16 + 15, mvp._33);
			}
			vertexBuffer2.unlock();
			buffs.push(vertexBuffer2);

			// draw all!
			g4.setTexture(textureID, image);
			g4.setVertexBuffers(buffs);
			g4.setIndexBuffer(indexBuffer);
			g4.drawIndexedVerticesInstanced(dataView.length, 0, indexBuffer.count());

			drawCallCount++;

			// clear data
			textureViewData.remove(image);
		}
	};
}
