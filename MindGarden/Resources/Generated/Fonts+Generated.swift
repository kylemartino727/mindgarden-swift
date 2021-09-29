// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

extension Font {
	/// Create a custom font with the given name and size that scales relative to the given textStyle.
	///
	/// Font is static in iOS 13.0
	public static func madaDynamic(_ style: MadaStyle, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
		if #available(iOS 14.0, *) {
			return Font.custom(style.rawValue, size: size, relativeTo: textStyle)
		} else {
			return Font.custom(style.rawValue, size: size)
		}
	}

	/// Create a custom font with the given name and size that scales with the body text style.
	public static func mada(_ style: MadaStyle, size: CGFloat) -> Font {
		return Font.custom(style.rawValue, size: size)
	}

	/// Create a custom font with the given name and a fixed size that does not scale with Dynamic Type.
	@available(iOS 14.0, *)
	public static func mada(_ style: MadaStyle, fixedSize: CGFloat) -> Font {
		return Font.custom(style.rawValue, fixedSize: fixedSize)
	}

	/// Create a custom font with the given name and size that scales relative to the given textStyle.
	@available(iOS 14.0, *)
	public static func mada(_ style: MadaStyle, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
		return Font.custom(style.rawValue, size: size, relativeTo: textStyle)
	}

	public enum MadaStyle: String {
		case bold = "Mada-Bold"
		case light = "Mada-Light"
		case medium = "Mada-Medium"
		case regular = "Mada-Regular"
		case semiBold = "Mada-SemiBold"
	}
}
