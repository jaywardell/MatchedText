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
            if found.upperBound <= index(startIndex, offsetBy: end) {
                let lastIndex = Swift.min(index(startIndex, offsetBy: end), endIndex)
                let out = String(self[..<lastIndex])
                return out + (lastIndex == endIndex ? "" : "…")
            }
            else {
                let firstIndex = found.lowerBound
                let suffix = self[firstIndex...]
                if suffix.count <= length {
                    return "…" + String(self[firstIndex ..< endIndex])
                }
                
//                let lastIndex = Swift.min(index(firstIndex, offsetBy: length), endIndex)
//                let out = String(self[firstIndex..<lastIndex])
//                return out
            }
        }
        
        return ""
    }
}
