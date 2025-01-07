//
//  Test.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import Testing
import MatchedText

struct String_MatchedSummary_Test {

    @Test func test_empty_returns_empty() async throws {
        let sut = ""
        
        #expect(sut.matchedSummary(length: 0, matching: "") == "")
    }

}
