package ui;

import kha.graphics2.Graphics;
import kha.Color;
import kha.Assets;

class Button {
	var listeners: Array<Void->Void>;
	var callback: Void->Void;
	var text: String;

	public var x: Int;
	public var y: Int;
	public var width: Int;
	public var height: Int;
	public var color: Color;

	public function new(x: Int, y: Int, width: Int, height: Int, color: Color, text: String, callback: Void->Void = null) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.color = color;
		this.listeners = [];
		this.callback = callback;
		this.text = text;

		kha.input.Mouse.get().notify(onMouseDown);
	}

	public function addListener(listener: Void->Void): Void {
		listeners.push(listener);
	}

	public function render(g: Graphics) {
		g.color = color;
		g.fillRect(x, y, width, height);

		if (text != null) {
			g.color = Color.Blue;
			g.font = Assets.fonts.RussoOne_Regular;
			g.fontSize = 20;
			g.drawString(this.text, this.x + 3, this.y + 3);
		}
	}

	public function onMouseDown(mouseButton: Int, mouseX: Int, mouseY: Int) {
		if (mouseButton == 0) {
			if (mouseX >= this.x && mouseX <= this.x + this.width && mouseY >= this.y && mouseY <= this.y + this.height) {
				for (listener in listeners) {
					listener();
				}
				if (callback != null)
					callback();
			}
		}
	}
}
