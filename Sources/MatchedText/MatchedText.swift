//
//  MatchedText.swift
//  MatchedText
//
//  Created by Joseph Wardell on 12/30/24.
//

import SwiftUI
import VisualDebugging

public extension EnvironmentValues {
    
    
    /// The string that MatchedText should highlight
    @Entry var matchedTextFilter: String = ""
    
    /// the maximum length of the String that a MatchedText instance should show.
    /// This will usually be nil, but in some cases you may want to set it
    /// so that the filter appears within the visible area of the View
    @Entry var maxMatchedTextLength: Int?
}

/// Presents an AttributedString with any instances of `searchFilter`
/// (taken from the @Environment) highlighted
public struct MatchedText: View {
    
    let text: AttributedString
    let highlight: (_ string: inout AttributedString,
                    _ range: Range<AttributedString.Index>,
                    _ font: Font?) -> Void

    @Environment(\.matchedTextFilter) var searchFilter
    @Environment(\.maxMatchedTextLength) var lineLength

    public init(
        text: AttributedString,
        highlight: @escaping (_ string: inout AttributedString,
                              _ range: Range<AttributedString.Index>,
                              _ font: Font?) -> Void = Self.defaultHighlight
    ) {
        self.text = text
        self.highlight = highlight
    }
    
    public var body: some View {
        HighlightedMatchingText(text: text, highlighted: searchFilter, maxLength: lineLength, highlight: highlight)
    }
}

// MARK: -

extension MatchedText {
    
    public static func defaultHighlight(_ string: inout AttributedString,
                                 in range: Range<AttributedString.Index>,
                                        font: Font?) {
        string[range].foregroundColor = .accentColor
    }
}

// MARK: -

public extension MatchedText {
    init(_ string: any StringProtocol,
         highlight: @escaping (
            _ string: inout AttributedString,
            _ range: Range<AttributedString.Index>,
            _ font: Font?) -> Void = Self.defaultHighlight) {
                
                self.init(text: AttributedString(string),
                  highlight: highlight
        )
    }
}

// MARK: -

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
            .environment(\.maxMatchedTextLength, 20)
    }
    .environment(\.matchedTextFilter, "e")
    .font(.body)
    .reasonablySizedPreview()
}
