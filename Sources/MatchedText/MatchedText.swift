//
//  MatchedText.swift
//  MatchedText
//
//  Created by Joseph Wardell on 12/30/24.
//

import SwiftUI
import VisualDebugging

extension EnvironmentValues {
    @Entry var searchFilter: String = ""
    @Entry var lineLength: Int?
}

/// Presents an AttributedString with any instances of `searchFilter`
/// (taken from the @Environment) highlighted
struct MatchedText: View {
    
    let text: AttributedString
    @Environment(\.searchFilter) var searchFilter
    @Environment(\.lineLength) var lineLength
    let highlight: (_ string: inout AttributedString,
                    _ range: Range<AttributedString.Index>) -> Void
    
    static func defaultHighlight(_ string: inout AttributedString,
                                 in range: Range<AttributedString.Index>) {
        string[range].foregroundColor = .accentColor
    }

    var body: some View {
        HighlightedMatchingText(text: text, highlighted: searchFilter, maxLength: lineLength, highlight: highlight)
    }
}

extension MatchedText {
    init(_ string: any StringProtocol, highlight: @escaping (_ string: inout AttributedString,
                                                             _ range: Range<AttributedString.Index>) -> Void = Self.defaultHighlight(_:in:)) {
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

        MatchedText(text: "Howdy World") { string, range in
            string[range].backgroundColor = .pink
        }
            .font(.largeTitle.bold())

        MatchedText(text: "Hi There World") { string, range in
            string[range].foregroundColor = .pink
        }
            .font(.largeTitle.bold())

        MatchedText(text: "Hello World") { string, range in
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
