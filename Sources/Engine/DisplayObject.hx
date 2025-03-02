package engine;

import kha.math.FastVector2;
import kha.math.FastVector4;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.math.FastVector3;

class DisplayObject implements IDrawable implements IUpdatable implements IResizable {
	public var children: Array<DisplayObject> = [];
	public var parent: DisplayObject = null;
	public var isVisible: Bool;
	public var pipeline: Pipeline;
	public var isActive: Bool;

	private var camera: Camera;

	// real
	@:isVar public var width(get, set): Float = 0;
	@:isVar public var height(get, set): Float = 0;
	@:isVar public var x(get, set): Float = 0;
	@:isVar public var y(get, set): Float = 0;
	@:isVar public var z(get, set): Float = 0;

	// view
	private var viewPosition: FastVector3;
	private var viewSize: FastVector2;

	public function new(x: Float, y: Float, width: Float, height: Float, camera: Camera, pipeline: Pipeline) {
		viewPosition = new FastVector3(0, 0, 0);
		viewSize = new FastVector2(0, 0);
		this.pipeline = pipeline;
		this.camera = camera;
		this.x = x;
		this.y = y;
		this.z = z;
		this.width = width;
		this.height = height;

		isVisible = true;
		isActive = true;
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
		updatePosition();
		return x;
	}

	function set_y(y) {
		this.y = y;
		updatePosition();
		return y;
	}

	function set_z(z) {
		this.z = z;
		updatePosition();
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
		this.updateSize();
		return width;
	}

	function set_height(height) {
		this.height = height;
		this.updateSize();
		return height;
	}

	private function updateSize() {
		// get max right and up position then create view size
		viewSize = Camera.ConvertGlobalPointToPerspectivePoint(width / 2, height / 2);
		viewSize.x *= 2;
		viewSize.y *= 2;
	}

	private function updatePosition() {
		var pos = Camera.ConvertGlobalPointToPerspectivePoint(x, y);
		viewPosition = new FastVector3(pos.x, pos.y, z);
	}

	public function addChild(object: DisplayObject): DisplayObject {
		this.children.push(object);
		return object;
	}

	public function removeChild(object: DisplayObject): DisplayObject {
		this.children.remove(object);
		return object;
	}

	public function render(g4: kha.graphics4.Graphics, batch: InstancedRender): Void {
		if (!isActive)
			return;

		for (child in children)
			child.render(g4, batch);

		// add data to batch
		// defined in overrided classes
	}

	public function update(currentTime: Float): Void {
		for (child in children)
			child.update(currentTime);

		if (!isActive)
			return;

		var rect: FastVector4 = camera.scope;

		// frustum culling
		isVisible = !(this.x + this.width <= rect.x - rect.z
			|| this.x - this.width >= rect.x + rect.z
			|| this.y + this.height <= rect.y - rect.w
			|| this.y - this.height >= rect.y + rect.w);
	}

	public function resize(): Void {
		for (child in children)
			child.resize();

		updatePosition();
		updateSize();
	}
}
