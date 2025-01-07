//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import Foundation

public let ellipsis: AttributedString = "…"

extension AttributedStringProtocol {
        
    public func matchedSummary(length: Int, matching filter: any StringProtocol) -> AttributedString {
        guard length >= filter.count,
              !filter.isEmpty
        else {
            return ""
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
        
        let range = beginning ..< ending
        var out = AttributedString(self[range])
        
        if ending < endIndex {
            out += ellipsis
        }
        if beginning > startIndex {
            out = ellipsis + out
        }
        
        return out
    }
}
