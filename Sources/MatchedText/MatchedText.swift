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
}

/// Presents an AttributedString with any instances of `searchFilter`
/// (taken from the @Environment) highlighted
struct MatchedText: View {
    
    let text: AttributedString
    @Environment(\.searchFilter) var searchFilter
    
    // TODO: it would be nice to have a macLength environment property (optional Int)
    // if it's set, then only show the part of the string surrounding the first found instance.
    
    var body: some View {
        HighlightedMatchingText(text: text, highlighted: searchFilter)
    }
}

extension MatchedText {
    init(_ string: any StringProtocol) {
        self.init(text: AttributedString(string))
    }
}

/// Most of the time, you will want to use MatchedText instead of this more conccrete View.
/// Presents an AttributedString with any matches to the `highlighted` string highlighted
/// in a way that makes it stand out.
struct HighlightedMatchingText: View {
    
    let text: AttributedString
    let highlighted: String

    @Environment(\.font) var font

    private func highlight(_ string: inout AttributedString,
                           in range: Range<AttributedString.Index>) {
        string[range].font = font?.weight(.semibold)
        string[range].underlineStyle = Text.LineStyle(
            pattern: .solid, color: .yellow)

    }
    
    var displayed: AttributedString {
        var out = text
        
        var start = text.startIndex
        var remaining = text[start...]
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
    init(_ text: any StringProtocol, filter: String) {
        self.init(text: AttributedString(text), highlighted: filter)
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

        HighlightedMatchingText(text: "Hello World", highlighted: "ll")
            .font(.largeTitle.bold())
    }
    .font(.body)
    .reasonablySizedPreview()
}

#Preview("Long HighlightedText") {
    List {
        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "over")
            .lineLimit(1)
        HighlightedMatchingText("The quick brown fox jumped over the lazy dog", filter: "quick")
            .lineLimit(1)
    }
    .reasonablySizedPreview()
}

#Preview("MatchedText") {
    List {
        MatchedText("My little buttercup")
        MatchedText("has the sweetest smile")
        MatchedText("deer little buttercup")
        MatchedText("won't you stay a while")

        MatchedText(text: "Howdy World")
            .font(.largeTitle.bold())
        MatchedText(text: "Hello World")
            .font(.largeTitle.bold())
    }
    .environment(\.searchFilter, "e")
    .font(.body)
    .reasonablySizedPreview()
}
