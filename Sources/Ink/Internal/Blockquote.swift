/**
 *  Ink
 *  Copyright (c) John Sundell 2019
 *  MIT license, see LICENSE file for details
 */

// MARK: - Blockquote

internal struct Blockquote: Fragment {
    var modifierTarget: Modifier.Target { .blockquotes }

    private var text: FormattedText

    static func read(using reader: inout Reader) throws -> Blockquote {
        try reader.read(">")
//        try reader.readWhitespaces()

        var text = FormattedText.readLine(using: &reader)
        while !reader.didReachEnd {
            switch reader.currentCharacter {
            case \.isNewline:
                guard let nextC = reader.nextCharacter, nextC.isQuoteMark else {
                    return Blockquote(text: text)
                }
                break
            case ">":
                reader.advanceIndex()
            default:
                break
            }
            text.addNewline()
            text.append(FormattedText.readLine(using: &reader))
        }

        return Blockquote(text: text)
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String
    {
        let body = text.html(usingURLs: urls, modifiers: modifiers)
        return "<blockquote><p>\(body)</p></blockquote>"
    }

    func plainText() -> String {
        text.plainText()
    }
}

internal extension Character {
    var isQuoteMark: Bool {
        isAny(of: .quoteMark)
    }
}

internal extension Set where Element == Character {
    static let quoteMark: Self = [">"]
}
