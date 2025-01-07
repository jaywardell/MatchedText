//
//  Test.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import Testing
import MatchedText

struct String_MatchedSummary_Test {

    @Test func empty_returns_empty() async throws {
        let sut = ""
        
        #expect(sut.matchedSummary(length: 0, matching: "") == "")
    }

    @Test func if_length_is_zero_returns_empty() async throws {
        let sut = "cat"
        
        #expect(sut.matchedSummary(length: 0, matching: "cat") == "")
    }

    @Test func if_matching_is_empty_returns_empty() async throws {
        let sut = "cat"
        
        #expect(sut.matchedSummary(length: 10, matching: "") == "")
    }

    @Test func if_matching_equals_self_returns_filter() async throws {
        let sut = "cat"
        let match = sut
        let expected = sut
        
        #expect(sut.matchedSummary(length: 10, matching: match) == expected)
    }
}
