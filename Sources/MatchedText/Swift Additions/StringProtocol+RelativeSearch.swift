//
//  StringProtocol+RelativeSearch.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/1/25.
//

extension StringProtocol {
        
    public func substringIsNearEnd(_ substring: any StringProtocol) -> Bool {
        let midway = index(self.startIndex, offsetBy: count/2)
        guard let found = range(of: substring) else { return false }
        return found.lowerBound >= midway
    }
}
