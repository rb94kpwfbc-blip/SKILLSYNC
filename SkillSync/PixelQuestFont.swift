import CoreText
import SwiftUI

enum PixelQuestFont {
    static let postScriptName = "PixelQuestForge"

    static func register() {
        guard let url = Bundle.main.url(
            forResource: "PixelQuestForge",
            withExtension: "ttf"
        ) else {
            return
        }

        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    static func ui(_ size: CGFloat) -> Font {
        .custom(postScriptName, fixedSize: size)
    }
}
