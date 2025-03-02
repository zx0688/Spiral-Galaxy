package;

import kha.graphics4.VertexBuffer;
import kha.graphics5_.VertexData;
import kha.graphics4.CullMode;
import kha.graphics4.Usage;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import haxe.Exception;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;

class Pipeline {
	// MVP
	@:isVar public var structureModel(get, default): VertexStructure;

	public function get_structureModel() {
		return this.structureModel;
	}

	// Vertices for simple rectangle image
	@:isVar public var structureVertices(get, default): VertexStructure;

	public function get_structureVertices() {
		return this.structureVertices;
	}

	@:isVar public var indexBuffer(get, default): IndexBuffer;

	public function get_indexBuffer() {
		return this.indexBuffer;
	}

	@:isVar public var vertexBuffer(get, default): VertexBuffer;

	public function get_vertexBuffer() {
		return this.vertexBuffer;
	}

	@:isVar public var state(get, default): PipelineState;

	public function get_state() {
		return this.state;
	}

	public function new() {
		structureVertices = new VertexStructure();
		structureVertices.add("pos", VertexData.Float3);
		structureVertices.add("uv", VertexData.Float2);

		structureModel = new VertexStructure();
		structureModel.add("MVP", VertexData.Float4x4);

		state = new PipelineState();
		state.inputLayout = [structureVertices, structureModel];
		state.vertexShader = Shaders.simple_vert;
		state.fragmentShader = Shaders.simple_frag;
		state.cullMode = CullMode.None;

		if (state.vertexShader == null || state.fragmentShader == null) {
			throw new Exception("shadera are not loaded!");
		}
		state.depthWrite = true;
		state.depthMode = CompareMode.Less;
		state.compile();

		var indices: Array<Int> = [0, 1, 2, 0, 2, 3];
		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

		// simple image rectangle
		var vertices = [
			-1, -1, 1.0, 0.0, 1.0, 1, -1, 1.0, 1.0, 1.0, 1, 1, 1.0, 1.0, 0.0, -1, 1, 1.0, 0.0, 0.0
		];
		vertexBuffer = new VertexBuffer(20, structureVertices, Usage.StaticUsage, 0);
		var iData = vertexBuffer.lock();
		for (v in 0...vertices.length) {
			iData.set(v, vertices[v]);
		}
		vertexBuffer.unlock();
	}
}
