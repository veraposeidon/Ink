//
//  CodeIndent.swift
//
//
//  Created by shenxiaohai on 2022/7/5.
//

internal struct CodeIndent: Fragment {
    var modifierTarget: Modifier.Target { .codeIndent }

    private static let marker: Character = " "

    private var code: String

    static func read(using reader: inout Reader) throws -> CodeIndent {
        let startingMarkerCount = reader.readCount(of: marker)
        try require(startingMarkerCount == 4)

        var code = ""
        while !reader.didReachEnd {
            if code.last == "\n" {
                let markerCount = reader.readCount(of: marker)
                if markerCount < startingMarkerCount {
                    break
                } else {
                    code.append(String(repeating: marker, count: markerCount - startingMarkerCount))
                    guard !reader.didReachEnd else { break }
                }
            }

            if let escaped = reader.currentCharacter.escaped {
                code.append(escaped)
            } else {
                code.append(reader.currentCharacter)
            }

            reader.advanceIndex()
        }
        while code.last == "\n" {
            code.remove(at: code.index(before: code.endIndex))
        }
        return CodeIndent(code: code)
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String
    {
        return "<pre><code>\(code)</code></pre>"
    }

    func plainText() -> String {
        code
    }
}
