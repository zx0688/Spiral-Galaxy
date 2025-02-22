package engine;

import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;

class DisplayObject implements IDrawable {
	public var children: Array<DisplayObject> = [];
	public var vertexBuffer: VertexBuffer = null;
	public var parent: DisplayObject = null;

	private var camera: Camera;
	private var indexBuffer: IndexBuffer;

	private var model: FastMatrix4;
	private var mvpID: ConstantLocation;

	@:isVar public var width(get, set): Float = 0;
	@:isVar public var height(get, set): Float = 0;

	@:isVar public var x(get, set): Float = 0;
	@:isVar public var y(get, set): Float = 0;

	public function new(x: Float, y: Float, width: Float, height: Float, camera: Camera) {
		this.camera = camera;
		this.width = width;
		this.height = height;
		this.x = x;
		this.y = y;

		mvpID = Pipeline.getInstance().pipeline.getConstantLocation("MVP");
		indexBuffer = Pipeline.getInstance().indexBuffer;
	}

	function get_x() {
		return this.x;
	}

	function get_y() {
		return this.y;
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
		this.vertexBuffer = new VertexBuffer(vertices.length, Pipeline.getInstance().structure, Usage.StaticUsage);
		var vbData = vertexBuffer.lock();
		for (i in 0...vertices.length) {
			vbData.set(i, vertices[i]);
		}
		this.vertexBuffer.unlock();
	}

	private function updateView() {
		var pos = Camera.ConvertGlobalPointToPerspective(x, y);
		model = FastMatrix4.identity();
		model = model.multmat(camera.projection);
		model = model.multmat(camera.view);
		model = model.multmat(FastMatrix4.translation(pos.x, pos.y, 0));
	}

	public function addChild(object: DisplayObject): Void {
		this.children.push(object);
	}

	public function removeChild(object: DisplayObject): Void {
		this.children.remove(object);
	}

	public function render(g4: kha.graphics4.Graphics): Void {
		g4.setMatrix(mvpID, model);
		g4.setVertexBuffer(vertexBuffer);
		g4.setIndexBuffer(indexBuffer);
		g4.drawIndexedVertices(0, indexBuffer.count());
	};
}
