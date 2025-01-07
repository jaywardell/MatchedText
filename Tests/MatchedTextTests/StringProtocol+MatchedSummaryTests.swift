//
//  Test.swift
//  MatchedText
//
//  Created by Joseph Wardell on 1/6/25.
//

import Testing
import Foundation
import MatchedText

struct String_MatchedSummary_Test {
    
    @Test func empty_returns_empty() async throws {
        let sut = AttributedString("")
        
        #expect(sut.matchedSummary(length: 0, matching: "") == "")
    }
    
    @Test func if_length_is_zero_returns_empty() async throws {
        let sut = AttributedString("cat")
        
        #expect(sut.matchedSummary(length: 0, matching: "cat") == "")
    }
    
    @Test func if_matching_is_empty_returns_empty() async throws {
        let sut = AttributedString("cat")

        #expect(sut.matchedSummary(length: 10, matching: "") == "")
    }
    
    @Test func if_matching_equals_self_returns_filter() async throws {
        let match = "cat"
        let sut = AttributedString(match)
        let expected = sut
        
        #expect(sut.matchedSummary(length: 10, matching: match) == expected)
    }
    
    @Test func if_filter_is_prefix_of_self_then_returns_first_length_characters_of_self() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "cat"
        let length = 6
        let expected = AttributedString("cat on" + "…")
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }
    
    @Test func if_filter_is_in_first_length_characters_of_self_then_returns_first_length_characters_of_self() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "on"
        let length = 6
        let expected = AttributedString("cat on") + "…"

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_first_length_characters_of_self_then_returns_first_length_characters_of_self2() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "on"
        let length = 7
        let expected = AttributedString("cat on ") + "…"

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_at_end_of_self_and_length_is_length_of_filter_then_returns_last_length_characters_of_self() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "roof"
        let length = match.count
        let expected = "…" + AttributedString("roof")

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_at_end_of_self_and_length_is_more_than_length_of_filter_then_returns_last_length_characters_of_self() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "roof"
        let length = match.count + 4
        let expected = "…" + AttributedString("tin roof")

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_near_end_of_self_and_length_is_more_than_length_of_filter_then_returns_last_length_characters_of_self() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "tin"
        let length = match.count + 5
        let expected = "…" + AttributedString("tin roof")

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_equal_to_length_of_filter_then_returns_filter() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "on"
        let length = match.count
        let expected = AttributedString("…" + match + "…")

        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_one_more_than_length_of_filter_then_returns_filter_plus_succeeding_character() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "on"
        let length = match.count + 1
        let expected = ellipsis + "on " + ellipsis
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_two_more_than_length_of_filter_then_returns_filter_plus_one_preceding_and_one_succeeding_characters() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "on"
        let length = match.count + 2
        let expected = ellipsis + " on " + ellipsis
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_four_more_than_length_of_filter_then_returns_filter_plus_two_preceding_and_two_succeeding_characters() async throws {
        let sut = AttributedString("cat on a tin roof")
        let match = "in"
        let length = match.count + 4
        let expected = ellipsis + " tin r" + ellipsis
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_five_more_than_length_of_filter_then_returns_filter_plus_two_preceding_and_three_succeeding_characters() async throws {
        let sut = AttributedString("cat on a tin roof sundae")
        let match = "in"
        let length = match.count + 5
        let expected = ellipsis + " tin ro" + ellipsis
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

    @Test func if_filter_is_in_center_self_and_length_eight_more_than_length_of_filter_then_returns_filter_plus_four_preceding_and_four_succeeding_characters() async throws {
        let sut = AttributedString("cat on a tin roof sundae")
        let match = "in"
        let length = match.count + 8
        let expected = ellipsis + " a tin roo" + ellipsis
        
        #expect(sut.matchedSummary(length: length, matching: match) == expected)
    }

}
