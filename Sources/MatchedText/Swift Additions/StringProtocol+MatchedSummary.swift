//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

extension StringProtocol {
    public func matchedSummary(length: Int, matching filter: any StringProtocol) -> String {
        guard length >= filter.count,
              !filter.isEmpty
        else {
            return "" }
        
        if let found = self.range(of: filter) {
            let end = Swift.min(length, count)
            
            // prefix
            if found.upperBound <= index(startIndex, offsetBy: end) {
                let lastIndex = Swift.min(index(startIndex, offsetBy: end), endIndex)
                let out = String(self[..<lastIndex])
                return out + (lastIndex == endIndex ? "" : "…")
            }
            else {
                let firstIndex = Swift.min(found.lowerBound,
                                           // don't worry about an index error here
                                           // length cannot be longer than count here
                                           index(endIndex, offsetBy: -length))
                let suffix = self[firstIndex...]
                
                // suffix
                if suffix.count <= length {
                    return "…" + String(self[firstIndex ..< endIndex])
                }
                else {
                    
                    // middle
                    return String(self[firstIndex ..< index(firstIndex, offsetBy: length)])
                }
                
                
//                let lastIndex = Swift.min(index(firstIndex, offsetBy: length), endIndex)
//                let out = String(self[firstIndex..<lastIndex])
//                return out
            }
        }
        
        return ""
    }
}
