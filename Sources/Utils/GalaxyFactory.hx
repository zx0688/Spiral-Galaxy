package utils;

import kha.math.Vector3;
import kha.System;
import kha.math.Random;

class GalaxyFactory {
	public static var allStarsInGalaxy: Array<Star> = [];

	public static function generateNewSpiralStar(totalStars: Int, galaxyRadius: Float, types: Array<Int>, camera: Camera, pipeline: Pipeline): Array<Star> {
		var a = 0.5;
		var b = 0.4;
		// var radius = 100;
		var armCount = 2;
		var newStars = [];
		var attempt;

		for (index in 0...totalStars) {
			var newStarParam = null;
			attempt = 0;
			do {
				newStarParam = createStar(a, b, index, totalStars, armCount, Math.floor(16 * Math.exp(-0.05 * attempt) + 2));
				attempt++;
			} while (isColliding(newStarParam) && attempt < 250);

			var mass = Main.random.GetFloatIn(0, 50) + 0.5;

			var newStar = new Star(newStarParam.x, newStarParam.y, newStarParam.z, mass, camera, pipeline);
			newStars.push(newStar);
			allStarsInGalaxy.push(newStar);
		}

		return newStars;
	}

	private static function createStar(a: Float, b: Float, index: Int, totalStars: Int, armCount: Int, maxStarRadius: Float): Vector3 {
		var theta = (index / totalStars) * Math.PI * 4;
		var r = Math.max(System.windowHeight(0),
			System.windowWidth(0)) * Main.random.GetFloatIn(0, 1) * (Math.exp(b * theta) * a); // a * Math.exp(b * theta) * (Math.random()) * 600;
		var angleOffset = (index % armCount) * (Math.PI * 2 / armCount) + (0.1 * Math.PI * Main.random.GetFloatIn(0, 1));
		var x = r * Math.cos(theta + angleOffset);
		var y = r * Math.sin(theta + angleOffset);
		var starRadius = Main.random.GetFloatIn(0, maxStarRadius) + 1;
		return new Vector3(x, y, starRadius);
	}

	private static function isColliding(newStar: Vector3): Bool {
		return Lambda.exists(allStarsInGalaxy, (star) -> {
			var dx = star.x - newStar.x;
			var dy = star.y - newStar.y;
			var distance: Float = dx * dx + dy * dy;
			var minDistance = star.width + newStar.z;
			return distance < minDistance * minDistance;
		});
	}
}
