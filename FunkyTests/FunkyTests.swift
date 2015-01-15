//
//  FunkyTests.swift
//  FunkyTests
//
//  Created by bryn austin bellomy on 2015 Jan 5.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import LlamaKit
import Funky

class FunkyTests: XCTestCase
{
    func testExample()
    {
        var funcWasCalled = false
        func missingValueError(value:String) -> Result<Int, NSError> {
            funcWasCalled = true
            return failure("missing value '\(value)'")
        }

        let result: Result<Int, NSError> = success(123) //failure("some failure")

        let asdf = result ?± failure("different failure")

//        if let desc = asdf.error?.localizedDescription {
//            XCTAssert(desc == "some failure", "failure message was '\(desc)'")
//        }

        XCTAssert(asdf.value == 123, "value was \(asdf.value)")
        XCTAssert(funcWasCalled == false, "function was called")
    }
}
