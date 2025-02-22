package simpleECS;

class Engine {
	private var entities: Array<Entity> = [];

	public function addEntity(entity: Entity): Void {
		entities.push(entity);
	}

	public function removeEntity(entity: Entity): Void {
		entities.remove(entity);
	}

	public function update(deltaTime: Float): Void {
		for (entity in entities) {
			entity.update(deltaTime);
		}
	}
}
