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

        if self.hasPrefix(filter) {
            let end = Swift.min(length, count)
            let endIndex = Swift.min(index(startIndex, offsetBy: end), endIndex)
            return String(self[..<endIndex])
        }

        if self.contains(filter) { return String(self) }
        
        
        return ""
    }
}
