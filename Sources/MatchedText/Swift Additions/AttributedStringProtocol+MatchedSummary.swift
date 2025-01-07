//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import Foundation

public let ellipsis: AttributedString = "…"

extension AttributedStringProtocol {
        
    private func rangeOfPreviewString(matching filter: any StringProtocol, length: Int) -> Range<AttributedString.Index> {
        guard length >= filter.count,
              !filter.isEmpty
        else {
            return startIndex ..< startIndex
        }
        
        var beginning: AttributedString.Index = startIndex
        var ending: AttributedString.Index = startIndex

        if let found = self.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) {
            let end = Swift.min(length, characters.count)
            
            // prefix
            if found.upperBound <= index(startIndex, offsetByCharacters: end) {
                let lastIndex = Swift.min(index(startIndex, offsetByCharacters: end), endIndex)
                ending = lastIndex
            }
            else {
                let firstIndex = Swift.min(found.lowerBound,
                                           // don't worry about an index error here
                                           // length cannot be longer than count here
                                           index(endIndex, offsetByCharacters: -length))
                let suffix = self[firstIndex...]
                
                // suffix
                if suffix.characters.count <= length {
                    beginning = firstIndex
                    ending = endIndex
                }
                else {
                    
                    // middle
                    let start = index(firstIndex, offsetByCharacters: -(length - filter.count)/2)
                    beginning = start
                    ending = index(start, offsetByCharacters: length)
                }
            }
        }
        return beginning ..< ending
    }
    
    public func previewString(matching filter: any StringProtocol, length: Int) -> AttributedString {

        let range = rangeOfPreviewString(matching: filter, length: length)
        guard !range.isEmpty else { return "" }
        
        var out = AttributedString(self[range])
        
        if range.upperBound < endIndex {
            out += ellipsis
        }
        if range.lowerBound > startIndex {
            out = ellipsis + out
        }
        
        return out
    }
}
