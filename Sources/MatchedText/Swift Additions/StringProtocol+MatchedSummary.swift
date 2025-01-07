//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

public let ellipsis: String = "…"

extension StringProtocol {
        
    public func matchedSummary(length: Int, matching filter: any StringProtocol) -> String {
        guard length >= filter.count,
              !filter.isEmpty
        else {
            return ""
        }
        
        if let found = self.range(of: filter) {
            let end = Swift.min(length, count)
            
            // prefix
            if found.upperBound <= index(startIndex, offsetBy: end) {
                let lastIndex = Swift.min(index(startIndex, offsetBy: end), endIndex)
                let out = String(self[..<lastIndex])
                return out + (lastIndex == endIndex ? "" : ellipsis)
            }
            else {
                let firstIndex = Swift.min(found.lowerBound,
                                           // don't worry about an index error here
                                           // length cannot be longer than count here
                                           index(endIndex, offsetBy: -length))
                let suffix = self[firstIndex...]
                
                // suffix
                if suffix.count <= length {
                    return ellipsis + String(self[firstIndex ..< endIndex])
                }
                else {
                    
                    // middle
                    let start = index(firstIndex, offsetBy: -(length - filter.count)/2)
                    let out = String(self[
                        start ..<
                        index(start, offsetBy: length)])
                    return ellipsis + out + ellipsis
                }
            }
        }
        
        return ""
    }
}
