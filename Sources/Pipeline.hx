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
	private static var instance: Pipeline;

	public static function getInstance(): Pipeline {
		if (instance == null) {
			instance = new Pipeline();
		}
		return instance;
	}

	@:isVar public var structure(get, default): VertexStructure;

	public function get_structure() {
		return this.structure;
	}

	@:isVar public var indexBuffer(get, default): IndexBuffer;

	public function get_indexBuffer() {
		return this.indexBuffer;
	}

	@:isVar public var pipeline(get, default): PipelineState;

	public function get_pipeline() {
		return this.pipeline;
	}

	private function new() {
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("uv", VertexData.Float2);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;

		if (pipeline.vertexShader == null || pipeline.fragmentShader == null) {
			throw new Exception("shadera are not loaded!");
		}
		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		pipeline.compile();

		var indices: Array<Int> = [0, 1, 2, 0, 2, 3];
		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
	}
}
