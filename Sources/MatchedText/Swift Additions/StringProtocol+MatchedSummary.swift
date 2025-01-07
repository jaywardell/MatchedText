//
//  StringProtocol+MatchedSummary.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

extension StringProtocol {
    public func matchedSummary(length: Int, matching filter: any StringProtocol) -> String {
        guard length > filter.count else { return "" }
        
        if self.contains(filter) { return String(self) }
        
        return ""
    }
}
