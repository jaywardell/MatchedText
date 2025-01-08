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
    let highlight: (_ string: inout AttributedString,
                    _ range: Range<AttributedString.Index>,
                    _ font: Font?) -> Void

    @Environment(\.font) var font
        
    var displayed: AttributedString {
        var out: AttributedString = maxLength.map {
            text.previewString(matching: highlighted, length: $0)
        } ?? text
        
        var start = out.startIndex
        var remaining = out[start...]
        repeat {
            if let found = remaining.range(
                of: highlighted,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) {
                highlight(&out, found, font)
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

// MARK: -

extension HighlightedMatchingText {
    static func defaultHighlight(_ string: inout AttributedString,
                                 in range: Range<AttributedString.Index>,
                                 font: Font?) {
        string[range].backgroundColor = .accentColor
        string[range].font = font?.bold() ?? .body
    }
}

// MARK: -

extension HighlightedMatchingText {
    init(
        _ text: any StringProtocol,
        filter: String,
        maxLength: Int? = nil,
        highlight: @escaping (_ string: inout AttributedString,
                              _ range: Range<AttributedString.Index>,
                              _ font: Font?) -> Void = Self.defaultHighlight
    ) {
        self.init(text: AttributedString(text), highlighted: filter, maxLength: maxLength, highlight: highlight)
    }
}

// MARK: -

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

        HighlightedMatchingText(text: "Hello World",
                                highlighted: "ll", maxLength: nil)
        { string, range, font  in
            string[range].font = font?.bold() ?? .body.bold()
        }
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

#Preview("max length") {
    
    let quickbrown = "The quick brown fox jumped over the lazy dog"
    
    return List {

        HighlightedMatchingText(quickbrown, filter: "over", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "quick", maxLength: 5)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "The", maxLength: 3)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "The", maxLength: 7)
            .lineLimit(1)
        
        HighlightedMatchingText(quickbrown, filter: "dog", maxLength: 3)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "dog", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "brown", maxLength: 5)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "brown", maxLength: 13)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "jumped", maxLength: 100)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: "", maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText(quickbrown, filter: quickbrown, maxLength: 10)
            .lineLimit(1)

        HighlightedMatchingText(
            quickbrown,
            filter: quickbrown,
            maxLength: quickbrown.count
        )
            .lineLimit(1)

        HighlightedMatchingText(
            quickbrown,
            filter: quickbrown,
            maxLength: quickbrown.count * 10
        )
            .lineLimit(1)

        HighlightedMatchingText(
            quickbrown,
            filter: "dog",
            maxLength: quickbrown.count * 10
        )
            .lineLimit(1)

        HighlightedMatchingText(
            quickbrown,
            filter: quickbrown,
            maxLength: quickbrown.count
        )
            .lineLimit(1)
            .narrowerPreview()

        HighlightedMatchingText(
            quickbrown,
            filter: "lazy dog",
            maxLength: quickbrown.count
        )
            .lineLimit(1)
            .narrowerPreview()

        // yes, the highlighted characters don't appear here,
        // but that's because of narrowerPreview()
        // it would be foolish to try to do something about it
        // on our end
        HighlightedMatchingText(
            quickbrown,
            filter: "jumped over",
            maxLength: quickbrown.count
        )
            .lineLimit(1)
            .narrowerPreview()

    }
    .reasonablySizedPreview()
}
