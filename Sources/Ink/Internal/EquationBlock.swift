//
//  EquationBlock.swift
//  
//
//  Created by shenxiaohai on 2022/7/3.
//

internal struct EquationBlock: Fragment {
    var modifierTarget: Modifier.Target { .equations }

    private static let marker: Character = "$"
    private var text: Substring
    private var count: Int

    static func read(using reader: inout Reader) throws -> EquationBlock {
        let startCout = reader.readCount(of: marker)
        try require(startCout == 2)
        let content = try reader.read(until: marker,
                                      allowWhitespace: true,
                                      allowLineBreaks: true)
        reader.rewindIndex()
        let endCount = reader.readCount(of: marker)
        try require(endCount == 2)

        return EquationBlock(text: content, count: startCout)
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String {
        let body = equationExpression()
        return "<p>\(body)</p>"
    }

    func plainText() -> String {
        equationExpression()
    }
}

private extension EquationBlock {
    func equationExpression() -> String {
        let prefix = String(repeatElement("$", count: count))
        return prefix + text + prefix
    }
}
