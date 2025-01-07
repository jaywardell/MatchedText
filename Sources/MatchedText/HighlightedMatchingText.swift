//
//  HighlightedMatchingText.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import SwiftUI

/// Most of the time, you will want to use MatchedText instead of this more conccrete View.
/// Presents an AttributedString with any matches to the `highlighted` string highlighted
/// in a way that makes it stand out.
struct HighlightedMatchingText: View {
    
    let text: AttributedString
    let highlighted: String
    let maxLength: Int?

    @Environment(\.font) var font

    private func highlight(_ string: inout AttributedString,
                           in range: Range<AttributedString.Index>) {
        string[range].font = font?.weight(.semibold)
        string[range].underlineStyle = Text.LineStyle(
            pattern: .solid, color: .yellow)

    }
    
    var displayed: AttributedString {
        var out: AttributedString = maxLength.map {
            text.matchedSummary(length: $0, matching: highlighted)
        } ?? text
        
        var start = out.startIndex
        var remaining = out[start...]
        repeat {
            if let found = remaining.range(
                of: highlighted,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) {
                highlight(&out, in: found)
                start = found.upperBound
            }
            else {
                start = remaining.endIndex
            }
            remaining = remaining[start ..< remaining.endIndex]
        } while !remaining.description.isEmpty

        return out
    }
    
    var body: some View {
        Text(displayed)
            .allowsTightening(true)
            .truncationMode(text.description.substringIsNearEnd(highlighted) ? .head : .tail)
    }
}


extension HighlightedMatchingText {
    init(_ text: any StringProtocol, filter: String, maxLength: Int? = nil) {
        self.init(text: AttributedString(text), highlighted: filter, maxLength: maxLength)
    }
}

#Preview("HighlightedText") {
    List {
        HighlightedMatchingText("Hello World", filter: "")
        HighlightedMatchingText("Hello World", filter: "goodbye mars")
        HighlightedMatchingText("Hello World", filter: "Hello")
        HighlightedMatchingText("Hello World", filter: "h")
        HighlightedMatchingText("Hello World", filter: "l")
        HighlightedMatchingText("Hello World", filter: "d")
        HighlightedMatchingText("Héllo World".prefix(5), filter: "e")
        HighlightedMatchingText("da doo ron ron ron, da doo ron ron", filter: "ron")

        HighlightedMatchingText(text: "Hello World", highlighted: "ll", maxLength: nil)
            .font(.largeTitle.bold())
    }
    .font(.body)
    .reasonablySizedPreview()
}

#Preview("Long HighlightedText") {
    List {
        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "over")
            .lineLimit(1)
        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: " quick")
            .lineLimit(1)
    }
    .reasonablySizedPreview()
}

#Preview("Long HighlightedText with max length") {
    List {

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "over", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "quick", maxLength: 5)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "The", maxLength: 3)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "The", maxLength: 7)
            .lineLimit(1)
        
        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "dog", maxLength: 3)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "dog", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "brown", maxLength: 5)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "brown", maxLength: 13)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "jumped", maxLength: 100)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "The quick brown fox jumped over the lazy dog", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText(
            "The quick brown fox jumped over the lazy dog",
            filter: "The quick brown fox jumped over the lazy dog",
            maxLength: "The quick brown fox jumped over the lazy dog".count
        )
            .lineLimit(1)

        HighlightedMatchingText(
            "The quick brown fox jumped over the lazy dog",
            filter: "The quick brown fox jumped over the lazy dog",
            maxLength: "The quick brown fox jumped over the lazy dog".count * 10
        )
            .lineLimit(1)

    }
    .reasonablySizedPreview()
}
