import kha.math.FastVector4;
import simpleECS.*;
import components.*;
import kha.System;
import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.Assets;
import kha.Image;
import kha.Scheduler;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import engine.*;

class Main {
	public static function main() {
		System.init({title: "Empty", width: 640, height: 480}, init);
	}

	static function init() {
		var game = new Empty();
		System.notifyOnRender(game.render);
	}
}

class Rectangle {
	public var vertices: Array<Float>;

	// Конструктор
	public function new(width: Float, height: Float) {
		vertices = [
			-width,
			-height,
			0.0,
			0.0,
			1.0, // Левый нижний угол
			width,
			-height,
			0.0,
			1.0,
			1.0, // Правый нижний угол
			width,
			height,
			0.0,
			1.0,
			0.0, // Правый верхний угол
			- width,
			height,
			0.0,
			0.0,
			0.0 // Левый верхний угол
		];
	}
}

class Empty {
	// An array of vertices to form a cube
	var vertices: Array<Float> = [
		-1.0,
		-1.0,
		0.0,
		0.0,
		1.0, // Левый нижний угол
		1.0,
		-1.0,
		0.0,
		1.0,
		1.0, // Правый нижний угол
		1.0,
		1.0,
		0.0,
		1.0,
		0.0, // Правый верхний угол
		- 1.0,
		1.0,
		0.0,
		0.0,
		0.0 // Левый верхний угол
	];

	// var vertices = [0, 0, 1, 0, 1, 1, 0, 1];
	// var vertices: Array<Float> = [
	// 	-1,
	// 	-1,
	// 	0,
	// 	0,
	// 	0, // Нижний левый угол (позиция x, y, z, текстурные координаты u, v)
	// 	1,
	// 	-1,
	// 	0,
	// 	1,
	// 	0, // Нижний правый угол
	// 	1,
	// 	1,
	// 	0,
	// 	1,
	// 	1, // Верхний правый угол
	// 	- 1,
	// 	1,
	// 	0,
	// 	0,
	// 	1 // Верхний левый угол
	// ];
	var indices: Array<Int> = [0, 1, 2, 0, 2, 3];

	var vertexBuffer: VertexBuffer;
	var indexBuffer: IndexBuffer;
	var pipeline: PipelineState;

	public var mvp: FastMatrix4;
	public var mvp2: FastMatrix4;

	public var mvpID: ConstantLocation;

	var model: FastMatrix4;

	public var view: FastMatrix4;
	public var projection: FastMatrix4;

	public var textureID: TextureUnit;
	public var image: Image;
	public var image2: Image;

	var lastTime = 0.0;

	var position: FastVector3 = new FastVector3(0, 0, 5); // Initial position: on +Z
	var horizontalAngle = 3.14; // Initial horizontal angle: toward -Z
	var verticalAngle = 0.0; // Initial vertical angle: none

	var moveForward = false;
	var moveBackward = false;
	var strafeLeft = false;
	var strafeRight = false;
	var isMouseDown = false;

	var mouseX = 0.0;
	var mouseY = 0.0;
	var mouseDeltaX = 0.0;
	var mouseDeltaY = 0.0;

	var speed = 3.0; // 3 units / second
	var mouseSpeed = 0.005;

	var started = false;

	var comp: ImageRender = null;
	var sphereMesh = null;
	var runTime: Float = 0;
	var io: ImageObject;
	var io2: ImageObject;

	public function new() {
		// Load all assets defined in khafile.js
		Assets.loadEverything(loadingFinished);

		comp = new ImageRender("dfdf");
	}

	function loadingFinished() {
		// Define vertex structure
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("uv", VertexData.Float2);
		// structure.add("normal", VertexData.Float3);
		// Save length - we store position and uv data
		var structureLength = 5;

		// Shaders are located in 'Sources/Shaders' directory
		// and Kha includes them automatically
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;

		if (pipeline.vertexShader == null || pipeline.fragmentShader == null) {
			trace("Ошибка: шейдеры не загружены или не скомпилированы.");
		}

		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		// Set depth mode
		// pipeline.depthWrite = true;
		// pipeline.depthMode = CompareMode.Less;
		// Set culling
		// pipeline.cullMode = CullMode.Clockwise;
		pipeline.compile();

		// Get a handle for our "MVP" uniform
		mvpID = pipeline.getConstantLocation("MVP");

		// Get a handle for texture sample
		textureID = pipeline.getTextureUnit("myTextureSampler");

		// Texture
		image = Assets.images.simple;
		image2 = Assets.images.simple2;

		// sphereMesh = SphereMesh.createSphere(1.0, 40, 40);
		// vertices = sphereMesh.vertices;
		// indices = sphereMesh.indices;

		// Устанавливаем ортогональную проекцию
		// projection = FastMatrix4.identity(); // FastMatrix4.orthogonalProjection(left, right, bottom, top, near, far);
		// Projection matrix: 45° Field of View, 4:3 ratio, display range : 0.1 unit <-> 100 units
		// var aspect = System.windowWidth(0) / System.windowHeight(0);
		// projection = FastMatrix4.orthogonalProjection(-10.0 * aspect, 10.0 * aspect, -10.0, 10.0, 0.0, 100.0);
		projection = FastMatrix4.perspectiveProjection(Camera.ANGLE_PERSPECTIVE, System.windowWidth(0) / System.windowHeight(0), 0.1, Camera.MAX_DISTANCE);
		// projection = FastMatrix4.orthogonalProjection(-10.0, 10.0, -10.0, 10.0, 0.0, 100.0);
		// Or, for an ortho camera
		// projection = FastMatrix4.orthogonalProjection(-10.0, 10.0, -10.0, 10.0, 0.0, 100.0); // In world coordinates

		// Camera matrix
		view = FastMatrix4.lookAt(new FastVector3(0, 0, 99), // Camera is at (4, 3, 3), in World Space
			new FastVector3(0, 0, 0), new FastVector3(0, 1, 0));
		// var cameraPosition = new FastVector3(0, 10, 0);
		// view = FastMatrix4.lookAt(cameraPosition, new FastVector3(0, 0, 0), new FastVector3(0, 0, 1));
		// view = FastMatrix4.lookAt(new FastVector3(0, 10, 0), new FastVector3(0, 0, 0), new FastVector3(1, 0, 0));
		// view = FastMatrix4.lookAt(new FastVector3(0, 10, 0), // Камера находится на высоте Y=10
		//	new FastVector3(0, 0, 0), // Камера смотрит на точку (0, 0, 0)
		//	new FastVector3(1, 0, 0));

		// Model matrix: an identity matrix (model will be at the origin)
		model = FastMatrix4.identity();

		// Our ModelViewProjection: multiplication of our 3 matrices
		// Remember, matrix multiplication is the other way around
		mvp = FastMatrix4.identity();
		mvp = mvp.multmat(projection);
		mvp = mvp.multmat(view);
		mvp = mvp.multmat(model);

		// 		mvp2 = mvp;

		// Настраиваем вершинный буфер

		// // Create vertex buffer
		vertexBuffer = new VertexBuffer(vertices.length, // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);

		vertices = []; // Camera.GenerateVertixForImageGlobalSize(640, 480);
		// Copy vertices and uvs to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vertices.length) {
			vbData.set(i, vertices[i]);
		}
		vertexBuffer.unlock();

		// A 'trick' to create indices for a non-indexed vertex data

		// Create index buffer
		indexBuffer = new IndexBuffer(indices.length, // Number of indices for our cube
			Usage.StaticUsage // Index data will stay the same
		);

		// // Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

		// Add mouse and keyboard listeners
		kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
		kha.input.Keyboard.get().notify(onKeyDown, onKeyUp);

		// Used to calculate delta time
		lastTime = Scheduler.time();

		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);

		Pipeline.getInstance();
		var camera = new Camera();

		io = new ImageObject(0, 0, 640, 480, image, camera);
		io2 = new ImageObject(0, 0, 100, 100, image2, camera);
		io.addChild(io2);

		started = true;
	}

	public function render(frame: Framebuffer) {
		var g = frame.g4;
		g.begin();
		if (started) {
			// Clear screen
			g.clear(Color.Black, 1.0);
			g.setPipeline(Pipeline.getInstance().pipeline);
			// io2.render(g);
			io.render(g);

			// g.setPipeline(pipeline);

			/*g.setTexture(textureID, image);
				g.setMatrix(mvpID, mvp);

				g.setVertexBuffer(vertexBuffer);
				g.setIndexBuffer(indexBuffer);
				//
				g.drawIndexedVertices(0, indexBuffer.count()); */

			//
			// 			g.setMatrix(mvpID, mvp2);
			// 			g.setTexture(textureID, image2);
			// 			// g.setTexture(textureID, image);
			//
			// 			// g.setVertexBuffer(vertexBuffer);
			// 			// g.setIndexBuffer(indexBuffer);
			//
			// 			g.drawIndexedVertices(0, indices.length);
		}
		g.end();
	}

	public function update() {
		// Compute time difference between current and last frame

		var currentTime = Scheduler.time();
		var deltaTime = currentTime - lastTime;
		runTime += deltaTime;
		lastTime = Scheduler.time();

		var rt = runTime;

		io2.x += 1;

		return;
		var cameraX: Float = 0;

		// Compute new orientation
		if (isMouseDown) {
			cameraX = mouseDeltaX;
		}

		// Direction : Spherical coordinates to Cartesian coordinates conversion

		// Movement
		// if (moveForward) {
		// 	var v = direction.mult(deltaTime * speed);
		// 	position = position.add(v);
		// }
		// if (moveBackward) {
		// 	var v = direction.mult(deltaTime * speed * -1);
		// 	position = position.add(v);
		// }
		// if (strafeRight) {
		// 	var v = right.mult(deltaTime * speed);
		// 	position = position.add(v);
		// }
		// if (strafeLeft) {
		// 	var v = right.mult(deltaTime * speed * -1);
		// 	position = position.add(v);
		// }
		var x = Math.cos(runTime) * 5;
		var y = Math.sin(runTime) * 5;

		// 		var fov = Math.PI / 4; // 45 градусов в радианах
		// 		var cameraDistance = 100; // Расстояние до камеры
		// 		var aspectRatio = System.windowWidth(0) / System.windowHeight(0);
		//
		// 		var halfHeight = cameraDistance * Math.tan(fov / 2) * aspectRatio;
		// 		var halfWidth = halfHeight * aspectRatio;

		view = FastMatrix4.lookAt(new FastVector3(0, 0, 99), new FastVector3(0, 0, 0), new FastVector3(0, 1, 0));

		// io.width -= runTime;

		// Применяем масштабирование
		// var scaleMatrix = FastMatrix4.scale(scaleX, scaleY, 1); // Масштабирование по X и Y
		// model = FastMatrix4.scale(1, 1, 0); // Применяем масштабирование к модели

		// model = FastMatrix4.translation(0, 0, 0.0);

		// Update model-view-projection matrix
		// 		mvp = FastMatrix4.identity();
		// 		mvp = mvp.multmat(projection);
		// 		mvp = mvp.multmat(view);
		// 		mvp = mvp.multmat(FastMatrix4.identity());
		//
		// 		mvp2 = FastMatrix4.identity();
		// 		mvp2 = mvp2.multmat(projection);
		// 		mvp2 = mvp2.multmat(view);
		// 		mvp2 = mvp2.multmat(FastMatrix4.identity());

		mouseDeltaX = 0;
		mouseDeltaY = 0;
	}

	function onMouseDown(button: Int, x: Int, y: Int) {
		isMouseDown = true;
	}

	function onMouseUp(button: Int, x: Int, y: Int) {
		isMouseDown = false;
	}

	function onMouseMove(x: Int, y: Int, movementX: Int, movementY: Int) {
		mouseDeltaX = x - mouseX;
		mouseDeltaY = y - mouseY;

		mouseX = x;
		mouseY = y;
	}

	function onKeyDown(key: Int) {
		if (key == KeyCode.Up)
			moveForward = true;
		else if (key == KeyCode.Down)
			moveBackward = true;
		else if (key == KeyCode.Left)
			strafeLeft = true;
		else if (key == KeyCode.Right)
			strafeRight = true;
	}

	function onKeyUp(key: Int) {
		if (key == KeyCode.Up)
			moveForward = false;
		else if (key == KeyCode.Down)
			moveBackward = false;
		else if (key == KeyCode.Left)
			strafeLeft = false;
		else if (key == KeyCode.Right)
			strafeRight = false;
	}
}
