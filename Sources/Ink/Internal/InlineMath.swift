//
//  InlineMath.swift
//  
//
//  Created by shenxiaohai on 2022/7/3.
//

struct InlineMath: Fragment {
    var modifierTarget: Modifier.Target { .inlineMath }

    private var mathExpression: String

    static func read(using reader: inout Reader) throws -> InlineMath {
        try reader.read("$")
        var expression = ""

        while !reader.didReachEnd {
            switch reader.currentCharacter {
            case \.isNewline:
                throw Reader.Error()
            case "$":
                reader.advanceIndex()
                return InlineMath(mathExpression: expression)
            default:
                expression.append(reader.currentCharacter)
                reader.advanceIndex()
            }
        }

        throw Reader.Error()
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String {
        return "$\(mathExpression)$"
    }

    func plainText() -> String {
        return "$\(mathExpression)$"
    }
}
