package engine;

import kha.Framebuffer;
import kha.graphics4.Usage;
import kha.graphics5_.TextureFormat;
import kha.graphics4.Graphics2;
import haxe.io.Bytes;
import haxe.io.BytesData;
import kha.Blob;
import kha.graphics4.Graphics;
import kha.Image;
import kha.Color;
import kha.System;
import kha.math.FastMatrix3;

class DynamicImageResizer {
	public static function init() {}

	public static function resizeTextures(cameraDistance: Float) {}

	private static function resizeImage(originalImage: Image, cameraDistance: Float): Image {
		var scale = clamp(1.0 / cameraDistance, 0.01, 1.0);
		var width = Math.floor(originalImage.width * scale);
		var height = Math.floor(originalImage.height * scale);

		var scaledImage: Image = Image.create(width, height);
		// scaleImage(originalImage, scaledImage, scale);

		return scaledImage;
	}

	public static function scaleImage(original: Image, scale: Float): Image {
		var width = Math.floor(original.width * scale);
		var height = Math.floor(original.height * scale);

		var pixels = Bytes.alloc(width * height * 4); // 4 байта на пиксель (RGBA)
		var i = Image.fromBytes(pixels, width, height, TextureFormat.RGBA32);

		// i.g2.begin();
		// i.g2.clear(Color.White);
		// i.g2.end();
		return original;

		// 		for (y in 0...height) {
		// 			for (x in 0...width) {
		// 				var srcX = Math.floor(x / scale);
		// 				var srcY = Math.floor(y / scale);
		//
		// 				if (srcX < original.width && srcY < original.height) {
		// 					var color = originalPixels.getInt32(srcX + srcY * original.width);
		// 					newPixels.setInt32(x + y * width, color);
		// 				}
		// 				else {
		// 					newPixels.setInt32(x + y * width, 0);
		// 				}
		// 			}
		// 		}
		//
		// 		return Image.fromBytes(newPixels, width, height, TextureFormat.RGBA32, Usage.StaticUsage);
	}

	static function clamp(value: Float, min: Float, max: Float): Float {
		if (value < min)
			return min;
		if (value > max)
			return max;
		return value;
	}
}
