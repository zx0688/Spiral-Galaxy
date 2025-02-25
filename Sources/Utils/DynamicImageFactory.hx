package utils;

import haxe.Exception;
import kha.Framebuffer;
import kha.graphics4.Usage;
import kha.graphics5_.TextureFormat;
import kha.graphics4.Graphics2;
import haxe.io.Bytes;
import haxe.io.BytesData;
import kha.Blob;
import kha.graphics4.Graphics;
import kha.Image;
import kha.Assets;
import kha.Color;
import kha.System;
import kha.math.FastMatrix3;

class DynamicImageFactory {
	public static inline var DISTANCE_THRESHOLD: Int = 40;

	// name - texture
	// low and high resolution
	private static var mipmapping: Map<String, Array<Image>> = new Map();

	public static function init() {
		mipmapping.set("red_gigant", [Assets.images.red_gigant_low, Assets.images.red_gigant_high]);
		mipmapping.set("white_dwarf", [Assets.images.white_dwarf_low, Assets.images.white_dwarf_high]);
		mipmapping.set("brown_dwarf", [Assets.images.brown_dwarf_low, Assets.images.brown_dwarf_high]);
		mipmapping.set("blue_gigant", [Assets.images.blue_gigant_low, Assets.images.blue_gigant_high]);
	}

	public static function getTexture(name: String, cameraDistance: Float, image: Image): Image {
		var list = mipmapping.get(name);
		if (list == null)
			return image;

		if (cameraDistance > DISTANCE_THRESHOLD)
			return list[0];
		else
			return list[1];
	}

	private static function resizeTextures(cameraDistance: Float) {}

	private static function dynamicResizeImage(originalImage: Image, cameraDistance: Float): Image {
		var scale = clamp(1.0 / cameraDistance, 0.01, 1.0);
		var width = Math.floor(originalImage.width * scale);
		var height = Math.floor(originalImage.height * scale);

		var scaledImage: Image = Image.create(width, height);
		scaleImage(originalImage, scale);
		return scaledImage;
	}

	// TODO Make scaled copy of image by g4
	public static function scaleImage(original: Image, scale: Float): Image {
		var width = Math.floor(original.width * scale);
		var height = Math.floor(original.height * scale);

		var newPixels = Bytes.alloc(width * height * 4);

		// i.g4.begin();
		// i.g4.clear(Color.White);
		// i.g4.sacle()
		// i.g4.end();
		return Image.fromBytes(newPixels, width, height, TextureFormat.RGBA32, Usage.StaticUsage);
	}

	static function clamp(value: Float, min: Float, max: Float): Float {
		if (value < min)
			return min;
		if (value > max)
			return max;
		return value;
	}
}
