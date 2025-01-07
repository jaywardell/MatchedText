//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

extension StringProtocol {
    public func matchedSummary(length: Int, matching filter: any StringProtocol) -> String {
        guard length > filter.count,
              !filter.isEmpty
        else { return "" }
        
        if let found = self.range(of: filter) {
            let end = Swift.min(length, count)
            if found.upperBound <= index(startIndex, offsetBy: end) {
                let lastIndex = Swift.min(index(startIndex, offsetBy: end), endIndex)
                let out = String(self[..<lastIndex])
                return out + (lastIndex == endIndex ? "" : "…")
            }
        }        
        
        return ""
    }
}
