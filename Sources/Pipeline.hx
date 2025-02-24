package;

import kha.graphics4.Usage;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import haxe.Exception;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;

class Pipeline {
	@:isVar public var structure(get, default): VertexStructure;

	public function get_structure() {
		return this.structure;
	}

	@:isVar public var indexBuffer(get, default): IndexBuffer;

	public function get_indexBuffer() {
		return this.indexBuffer;
	}

	@:isVar public var state(get, default): PipelineState;

	public function get_state() {
		return this.state;
	}

	public function new() {
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("uv", VertexData.Float2);

		state = new PipelineState();
		state.inputLayout = [structure];
		state.vertexShader = Shaders.simple_vert;
		state.fragmentShader = Shaders.simple_frag;

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
	}
}
