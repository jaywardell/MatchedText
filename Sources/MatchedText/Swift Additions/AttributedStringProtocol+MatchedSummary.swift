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
        
        if let found = self.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) {
            let end = Swift.min(length, characters.count)
            
            // prefix
            if found.upperBound <= index(startIndex, offsetByCharacters: end) {
                let lastIndex = Swift.min(index(startIndex, offsetByCharacters: end), endIndex)
                let out = AttributedString(self[..<lastIndex])
                return out + (lastIndex == endIndex ? "" : ellipsis)
            }
            else {
                let firstIndex = Swift.min(found.lowerBound,
                                           // don't worry about an index error here
                                           // length cannot be longer than count here
                                           index(endIndex, offsetByCharacters: -length))
                let suffix = self[firstIndex...]
                
                // suffix
                if suffix.characters.count <= length {
                    return ellipsis + AttributedString(self[firstIndex ..< endIndex])
                }
                else {
                    
                    // middle
                    let start = index(firstIndex, offsetByCharacters: -(length - filter.count)/2)
                    let out = AttributedString(self[
                        start ..<
                        index(start, offsetByCharacters: length)])
                    return ellipsis + out + ellipsis
                }
            }
        }
        
        return ""
    }
}
