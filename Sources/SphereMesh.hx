class SphereMesh {
	public static function createImageMesh(width: Float, height: Float): Dynamic {
		var vertices = new Array<Float>(); // хранит x, y, z, texCoordX, texCoordY, normalX, normalY, normalZ
		var indices = new Array<Int>();

		// Создаем 4 вершины для плоского изображения (квадрата)
		var halfWidth = width / 2;
		var halfHeight = height / 2;

		// Вершины для квадрата (положения, текстурные координаты, нормали)
		var positions = [
			-halfWidth,
			-halfHeight,
			0, // Левый нижний угол
			halfWidth,
			-halfHeight,
			0, // Правый нижний угол
			halfWidth,
			halfHeight,
			0, // Правый верхний угол
			- halfWidth,
			halfHeight,
			0 // Левый верхний угол
		];

		// Текстурные координаты для квадрата (сначала левый нижний угол, затем по часовой стрелке)
		var texCoords = [
			0.0,
			1.0, // Левый нижний
			1.0,
			1.0, // Правый нижний
			1.0,
			0.0, // Правый верхний
			0.0,
			0.0 // Левый верхний
		];

		// Нормали (для плоской поверхности нормали будут одинаковыми для всех вершин)
		var normal = [0.0, 0.0, 1.0]; // Нормаль к плоской поверхности (вектор вдоль оси Z)

		// Добавляем вершины в массив
		for (i in 0...4) {
			vertices.push(positions[i * 3]); // x
			vertices.push(positions[i * 3 + 1]); // y
			vertices.push(positions[i * 3 + 2]); // z
			vertices.push(texCoords[i * 2]); // texCoordX
			vertices.push(texCoords[i * 2 + 1]); // texCoordY
			vertices.push(normal[0]); // normalX
			vertices.push(normal[1]); // normalY
			vertices.push(normal[2]); // normalZ
		}

		// Индексы для создания треугольников (включает два треугольника для квадрата)
		indices.concat([0, 1, 2]);
		indices.concat([2, 3, 0]);

		return {vertices: vertices, indices: indices};
	}

	public static function createSphere(radius: Float, segmentsWidth: Int, segmentsHeight: Int): Dynamic {
		var vertices = new Array<Float>(); // хранит x, y, z, texCoordX, texCoordY, normalX, normalY, normalZ
		var indices = new Array<Int>();

		for (i in 0...segmentsHeight + 1) {
			var phi = Math.PI * i / segmentsHeight;
			for (j in 0...segmentsWidth) {
				var theta = 2 * Math.PI * j / segmentsWidth;

				// Позиции вершин
				var x = radius * Math.sin(phi) * Math.cos(theta);
				var y = radius * Math.sin(phi) * Math.sin(theta);
				var z = radius * Math.cos(phi);

				// Нормали (единичные векторы, указывающие на поверхность сферы)
				var nx = Math.sin(phi) * Math.cos(theta);
				var ny = Math.sin(phi) * Math.sin(theta);
				var nz = Math.cos(phi);

				// Текстурные координаты (могут быть использованы для наложения текстуры)
				var u = j / segmentsWidth;
				var v = i / segmentsHeight;

				// Добавляем вершины по очереди
				vertices.push(x);
				vertices.push(y);
				vertices.push(z);
				vertices.push(u);
				vertices.push(v);
				vertices.push(nx);
				vertices.push(ny);
				vertices.push(nz);

				// Индексы для треугольников
				if (i < segmentsHeight && j < segmentsWidth) {
					var nextI = i + 1;
					var nextJ = (j + 1) % segmentsWidth;

					var index1 = i * segmentsWidth + j;
					var index2 = nextI * segmentsWidth + j;
					var index3 = i * segmentsWidth + nextJ;
					var index4 = nextI * segmentsWidth + nextJ;

					indices.push(index1);
					indices.push(index2);
					indices.push(index3);
					indices.push(index3);
					indices.push(index2);
					indices.push(index4);
				}
			}
		}

		return {vertices: vertices, indices: indices};
	}

	public static function createSpher2e(radius: Float, segments: Int): Dynamic {
		var vertices = new Array<Float>();
		var indices = new Array<Int>();

		for (i in 0...segments + 1) {
			var theta: Float = Math.PI * (i / segments);
			for (j in 0...segments + 1) {
				var phi: Float = 2 * Math.PI * (j / segments);
				var x: Float = radius * Math.sin(theta) * Math.cos(phi);
				var y: Float = radius * Math.cos(theta);
				var z: Float = radius * Math.sin(theta) * Math.sin(phi);

				vertices.push(x);
				vertices.push(y);
				vertices.push(z);

				// Текстурные координаты
				var u: Float = 1 - (j / segments);
				var v: Float = 1 - (i / segments);
				vertices.push(u);
				vertices.push(v);

				// Нормали
				vertices.push(x / radius);
				vertices.push(y / radius);
				vertices.push(z / radius);
			}
		}

		for (i in 0...segments) {
			for (j in 0...segments) {
				var first: Int = (i * (segments + 1)) + j;
				var second: Int = first + segments + 1;

				indices.push(first);
				indices.push(second);
				indices.push(first + 1);

				indices.push(second);
				indices.push(second + 1);
				indices.push(first + 1);
			}
		}

		return {vertices: vertices, indices: indices};
	}
}
