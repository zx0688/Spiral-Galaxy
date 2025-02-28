package engine;

import kha.math.FastVector4;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.math.FastVector3;

class DisplayObject implements IDrawable implements IUpdatable implements IResizable {
	public var children: Array<DisplayObject> = [];
	public var vertexBuffer: VertexBuffer = null;
	public var parent: DisplayObject = null;
	public var isVisible: Bool;
	public var pipeline: Pipeline;
	public var isActive: Bool;

	private var camera: Camera;
	private var indexBuffer: IndexBuffer;
	private var model: FastMatrix4;
	private var mvpID: ConstantLocation;

	@:isVar public var width(get, set): Float = 0;
	@:isVar public var height(get, set): Float = 0;
	@:isVar public var x(get, set): Float = 0;
	@:isVar public var y(get, set): Float = 0;
	@:isVar public var z(get, set): Float = 0;

	public function new(x: Float, y: Float, width: Float, height: Float, camera: Camera, pipeline: Pipeline) {
		model = FastMatrix4.identity();
		this.pipeline = pipeline;
		this.camera = camera;
		this.width = width;
		this.height = height;
		this.x = x;
		this.y = y;
		this.z = z;
		isVisible = true;
		isActive = true;

		mvpID = pipeline.state.getConstantLocation("MVP");
		indexBuffer = pipeline.indexBuffer;
	}

	function get_x() {
		return this.x;
	}

	function get_y() {
		return this.y;
	}

	function get_z() {
		return this.z;
	}

	function set_x(x) {
		this.x = x;
		updateView();
		return x;
	}

	function set_y(y) {
		this.y = y;
		updateView();
		return y;
	}

	function set_z(z) {
		this.z = z;
		updateView();
		return z;
	}

	function get_width() {
		return this.width;
	}

	function get_height() {
		return this.height;
	}

	function set_width(width) {
		this.width = width;
		this.updateVertexBuffer();
		return width;
	}

	function set_height(height) {
		this.height = height;
		this.updateVertexBuffer();
		return height;
	}

	private function updateVertexBuffer() {
		var vertices = Camera.GenerateVertixForImageGlobalSize(width, height);
		this.vertexBuffer = new VertexBuffer(vertices.length, pipeline.structure, Usage.StaticUsage);
		var vbData = vertexBuffer.lock();
		for (i in 0...vertices.length) {
			vbData.set(i, vertices[i]);
		}
		this.vertexBuffer.unlock();
	}

	public function updateView() {
		var pos = Camera.ConvertGlobalPointToPerspectivePoint(x, y);
		model = FastMatrix4.identity();
		model = model.multmat(camera.projection);
		model = model.multmat(camera.view);
		model = model.multmat(FastMatrix4.translation(pos.x, pos.y, z));
	}

	public function addChild(object: DisplayObject): DisplayObject {
		this.children.push(object);
		return object;
	}

	public function removeChild(object: DisplayObject): DisplayObject {
		this.children.remove(object);
		return object;
	}

	public function render(g4: kha.graphics4.Graphics, batch: BatchRender): Void {
		if (!isActive)
			return;

		for (child in children)
			child.render(g4, batch);

		if (!isVisible)
			return;

		g4.setMatrix(mvpID, model);
		g4.setVertexBuffer(vertexBuffer);
		g4.setIndexBuffer(indexBuffer);
		g4.drawIndexedVertices(0, indexBuffer.count());
	};

	public function update(currentTime: Float): Void {
		for (child in children)
			child.update(currentTime);

		var rect: FastVector4 = camera.scope;

		// frustum culling
		isVisible = !(this.x + this.width <= rect.x - rect.z
			|| this.x - this.width >= rect.x + rect.z
			|| this.y + this.height <= rect.y - rect.w
			|| this.y - this.height >= rect.y + rect.w);

		if (isVisible) {
			updateView();
		}
	}

	public function resize(): Void {
		for (child in children)
			child.resize();

		updateView();
		updateVertexBuffer();
	}
}
