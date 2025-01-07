//
//  MultilineMatchedText.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/1/25.
//

import SwiftUI

/// Like a normal MatchedText, but only shows the lines that have matches
public struct MultilineMatchedText: View {
    
    let text: String
    let highlight: (_ string: inout AttributedString,
                    _ range: Range<AttributedString.Index>) -> Void

    @Environment(\.searchFilter) var searchFilter

    public init(text: String,
         highlight: @escaping (_: inout AttributedString, _: Range<AttributedString.Index>) -> Void = MatchedText.defaultHighlight) {
        self.text = text
        self.highlight = highlight
    }
    
    private var matchingLines: [String] {
        text.components(separatedBy: .newlines)
            .filter { $0.localizedCaseInsensitiveContains(searchFilter) }
    }
    
    
    public var body: some View {
        // yes, there could be duplicate lines here,
        // but the point is to show a concise view
        // so duplicates should be ignored anyway
        VStack(alignment: .leading) {
            ForEach(0 ..< matchingLines.count, id: \.self) { index in
                let line = matchingLines[index]
                MatchedText(line, highlight: highlight)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    MultilineMatchedText(text:
    """
        I think that I shall never see
        A poem lovely as a tree.
        
        A tree whose hungry mouth is prest
        Against the earth's sweet flowing breast;
        
        A tree that looks at God all day,
        And lifts her leafy arms to pray;
        
        A tree that may in summer wear
        A nest of robins in her hair;
        
        Upon whose bosom snow has lain;
        Who intimately lives with rain.
        
        Poems are made by fools like me,
        But only God can make a tree.
        
        -- Joyce Kilmer
    """
     // from https://poets.org/poem/trees
    )
    .environment(\.searchFilter, "tree")
    .padding(.horizontal)
    .frame(width: 150)
}

#Preview {
    MultilineMatchedText(text:
    """
     I think that I shall never see
     A poem lovely as a tree.
     
     A tree whose hungry mouth is prest
     Against the earth's sweet flowing breast;
     
     A tree that looks at God all day,
     And lifts her leafy arms to pray;
     
     A tree that may in summer wear
     A nest of robins in her hair;
     
     Upon whose bosom snow has lain;
     Who intimately lives with rain.
     
     Poems are made by fools like me,
     But only God can make a tree.
     
     -- Joyce Kilmer
    """
     // from https://poets.org/poem/trees
    ) { string, range in
        string[range].foregroundColor = .teal
        string[range].font = .title3.bold().italic()
    }
    .environment(\.searchFilter, "ee")
    .environment(\.lineLength, 25)
    .padding()
}
