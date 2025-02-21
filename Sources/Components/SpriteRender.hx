package components;

import simpleECS.Component;

class SpriteRenderer extends Component {
	public var texture:String;

	public function new(texture:String) {
		this.texture = texture;
	}

	override public function update(deltaTime:Float):Void {
		// Логика отрисовки спрайта
	}
}
