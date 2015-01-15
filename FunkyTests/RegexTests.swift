//
//  RegexTests.swift
//  Funky
//
//  Created by John Holdsworth on 26/06/2014.
//  Copyright (c) 2014 John Holdsworth. All rights reserved.
//

import Foundation
import XCTest
import Funky


class RegexTests: XCTestCase
{
    func testExample()
    {
        let input = "The quick brown fox jumps over the lazy dog."
        XCTAssert(input["quick .* fox"].match() == "quick brown fox")

        if let noMatch = input["quick orange fox"].match() {
            XCTAssert(false, "non-match fail")
        }
        else {
            XCTAssert(true, "non-match pass")
        }

        var match: [String] = input["the .* dog"].matches()
        XCTAssert(match == ["the lazy dog"])
        XCTAssert(input["quick brown (\\w+)"][1] == "fox")
        XCTAssert(input["(the lazy) (cat)?"].groups()[2] == "_")

        let groups = input["the (.*?) (fox|dog)", .CaseInsensitive].allGroups()
        XCTAssert(groups == [["The quick brown fox", "quick brown", "fox"],
                             ["the lazy dog", "lazy", "dog"]], "groups match")

        let minput = NSMutableString(string:input)

        minput["(the) (\\w+)"] ~= "$1 very $2"
        XCTAssert(minput == "The quick brown fox jumps over the very lazy dog.", "replace pass")

        minput["(fox|dog)"] ~= ["$0", "brown $1"]
        XCTAssert(minput == "The quick brown fox jumps over the very lazy brown dog.", "replace array pass")

        minput["(\\w)(\\w+)"] ~= { (groups:[String]) in groups[1].uppercaseString + groups[2] }
        XCTAssert(minput == "The Quick Brown Fox Jumps Over The Very Lazy Brown Dog.", "block pass")

        minput["Quick (\\w+)"][1] = "Red $1"
        XCTAssert(minput == "The Quick Red Brown Fox Jumps Over The Very Lazy Brown Dog.", "group replace pass")

        var str: String = minput
        str += minput

        let props = "name1=value1\nname2='value2\nvalue2\n'\n"
        let dict  = props["(\\w+)=('[^']*'|.*)"].dictionary()
        XCTAssert(dict == ["name1": "value1", "name2": "'value2\nvalue2\n'"])
    }
}





