package components;

import Main.Empty;
import kha.math.FastMatrix4;
import Main.Empty;
import kha.graphics4.*;
import simpleECS.*;

class ImageRender {
	public var texture: String;

	public function new(texture: String) {
		this.texture = texture;
	}

	// public function update(deltaTime:Float):Void {}
	public function render(g4: kha.graphics4.Graphics): Void {
		// var mvp: FastMatrix4 = null;
		var centerX = 0; // Центр по X
		var centerY = 1.0; // Центр по Y
		var centerZ = -5.0; // Центр по Z (отдаляем изображение, чтобы оно было видно)

		var model = FastMatrix4.translation(centerX, centerY, centerZ);

		/*mvp = FastMatrix4.identity();
			mvp = mvp.multmat(Empty.projection);
			mvp = mvp.multmat(Empty.view);
			mvp = mvp.multmat(FastMatrix4.identity());
		 */
		// g4.setMatrix(Empty.mvpID, Empty.mvp);
		// g4.setTexture(Empty.textureID, Empty.image);
		// g4.drawIndexedVertices(0, 6);
	};
}
