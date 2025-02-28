package utils;

import kha.math.Vector4;
import kha.System;
import kha.math.Random;

class GalaxyFactory {
	// total count of stars
	public static var allStarsInGalaxy: Array<Star> = [];

	public static function generateNewSpiralStar(totalStars: Int, galaxyRadius: Float, types: Array<Int>, camera: Camera, pipeline: Pipeline,
			settings: Dynamic): Array<Star> {
		// range by mass
		var starClasses = [
			{min: 0, max: 30, type: "red_gigant"},
			{min: 30, max: 35, type: "blue_gigant"},
			{min: 35, max: 45, type: "brown_dwarf"},
			{min: 45, max: 100, type: "white_dwarf"}
		];
		var availableTypes: Array<String> = cast Reflect.field(settings, "availableTypes");
		starClasses = starClasses.filter(starClass -> availableTypes.indexOf(starClass.type) != -1);

		// emulate spiral galaxy
		var a = 0.5;
		var b = 0.4;
		var armCount = 2;
		var newStars = [];
		var attempt;

		for (index in 0...totalStars) {
			// create position
			var newStarParam = null;
			attempt = 0;
			do {
				newStarParam = createStar(a, b, index, totalStars, armCount, Math.floor(16 * Math.exp(-0.05 * attempt) + 2));
				attempt++;
			} while (isColliding(newStarParam) && attempt < 250);

			var starType: String = null;
			var mass: Float = 0;
			// create type by mass
			do {
				var mass = Main.random.GetFloatIn(0, 50);
				for (range in starClasses) {
					if (mass >= range.min && mass < range.max) {
						starType = range.type;
						break;
					}
				}
			} while (starType == null);

			var newStar = new Star(newStarParam.x, newStarParam.y, newStarParam.w, newStarParam.z, mass, starType, camera, pipeline);

			newStars.push(newStar);
			allStarsInGalaxy.push(newStar);
		}

		return newStars;
	}

	private static function createStar(a: Float, b: Float, index: Int, totalStars: Int, armCount: Int, maxStarRadius: Float): Vector4 {
		var theta = (index / totalStars) * Math.PI * 4;
		var r = Math.max(System.windowHeight(0),
			System.windowWidth(0)) * Main.random.GetFloatIn(0, 1) * (Math.exp(b * theta) * a); // a * Math.exp(b * theta) * (Math.random()) * 600;
		var angleOffset = (index % armCount) * (Math.PI * 2 / armCount) + (0.1 * Math.PI * Main.random.GetFloatIn(0, 1));
		var x = r * Math.cos(theta + angleOffset);
		var y = r * Math.sin(theta + angleOffset);
		var starRadius = Main.random.GetFloatIn(0, maxStarRadius) + 1;
		var rotation: Float = Main.random.GetFloatIn(0, 360);
		return new Vector4(x, y, starRadius, rotation);
	}

	// squares method
	private static function isColliding(newStar: Vector4): Bool {
		return Lambda.exists(allStarsInGalaxy, (star) -> {
			var dx = star.x - newStar.x;
			var dy = star.y - newStar.y;
			var distance: Float = dx * dx + dy * dy;
			var minDistance = star.width + newStar.z;
			return distance < minDistance * minDistance;
		});
	}
}
