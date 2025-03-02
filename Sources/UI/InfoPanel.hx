package ui;

import kha.graphics2.Graphics;
import kha.Color;
import kha.Assets;

class InfoPanel {
	public var x: Int;
	public var y: Int;
	public var width: Int;
	public var height: Int;

	var texts: Array<String> = [];

	public function new(x: Int, y: Int) {
		this.x = x;
		this.y = y;
	}

	public function addText(text: String) {
		texts.push(text);
		height = texts.length * 26;
		width = Lambda.fold(texts, function(text: String, current: Int) {
			return cast Math.max(text.length * 12, current);
		}, 0);
	}

	public function render(g: Graphics) {
		// texts
		g.color = Color.fromFloats(0, 0, 0, 0.5);
		g.fillRect(0, 0, width, height);
		g.color = Color.Green;
		g.font = Assets.fonts.RussoOne_Regular;
		g.fontSize = 25;
		for (i in 0...texts.length) {
			g.drawString(texts[i], x, y + i * 25);
		}
		texts = [];
	}
}
