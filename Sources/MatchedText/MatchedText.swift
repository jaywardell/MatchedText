//
//  MatchedText.swift
//  MatchedText
//
//  Created by Joseph Wardell on 12/30/24.
//

import SwiftUI
import VisualDebugging

public extension EnvironmentValues {
    @Entry var searchFilter: String = ""
    @Entry var lineLength: Int?
}

/// Presents an AttributedString with any instances of `searchFilter`
/// (taken from the @Environment) highlighted
public struct MatchedText: View {
    
    let text: AttributedString
    @Environment(\.searchFilter) var searchFilter
    @Environment(\.lineLength) var lineLength
    let highlight: (_ string: inout AttributedString,
                    _ range: Range<AttributedString.Index>,
                    _ font: Font?) -> Void
    
    public init(
        text: AttributedString,
        highlight: @escaping (_ string: inout AttributedString,
                              _ range: Range<AttributedString.Index>,
                              _ font: Font?) -> Void = Self.defaultHighlight
    ) {
        self.text = text
        self.highlight = highlight
    }
    
    public static func defaultHighlight(_ string: inout AttributedString,
                                 in range: Range<AttributedString.Index>,
                                        font: Font?) {
        string[range].foregroundColor = .accentColor
    }

    public var body: some View {
        HighlightedMatchingText(text: text, highlighted: searchFilter, maxLength: lineLength, highlight: highlight)
    }
}

public extension MatchedText {
    init(_ string: any StringProtocol, highlight: @escaping (_ string: inout AttributedString,
                                                             _ range: Range<AttributedString.Index>,
                                                             _ font: Font?) -> Void = Self.defaultHighlight) {
        self.init(text: AttributedString(string),
                  highlight: highlight
        )
    }
}


#Preview("MatchedText") {
    List {
        MatchedText("My little buttercup")
        MatchedText("has the sweetest smile")
        MatchedText("dear little buttercup")
        MatchedText("won't you stay a while")

        MatchedText(text: "Howdy World") { string, range, _ in
            string[range].backgroundColor = .pink
        }
            .font(.largeTitle.bold())

        MatchedText(text: "Hi There World") { string, range, _ in
            string[range].foregroundColor = .pink
        }
            .font(.largeTitle.bold())

        MatchedText(text: "Hello World") { string, range, _ in
            string[range].backgroundColor = .orange
        }
            .font(.largeTitle.bold())
        MatchedText("The quick brown fox jumped over the lazy dog")
            .lineLimit(1)
            .environment(\.lineLength, 20)
    }
    .environment(\.searchFilter, "e")
    .font(.body)
    .reasonablySizedPreview()
}
