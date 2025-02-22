package simpleECS;

class Entity {
	public function main() {}

	private var components: Array<Component> = [];

	public function addComponent(component: Component): Void {
		components.push(component);
	}

	public function getComponent<T: Component>(type: Class<T>): T {
		// for (component in components) {
		// 	if (Std.is(component, type)) {
		// 		return cast(component, T);
		// 	}
		// }
		return null;
	}

	public function update(deltaTime: Float): Void {
		for (component in components) {
			component.update(deltaTime);
		}
	}
}
