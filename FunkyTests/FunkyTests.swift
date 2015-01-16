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
        func missingValueError(value:String) -> Result<Int> {
            funcWasCalled = true
            return failure("missing value '\(value)'")
        }

        let result: Result<Int> = success(123) //failure("some failure")

        let asdf = result ?± failure("different failure")

//        if let desc = asdf.error?.localizedDescription {
//            XCTAssert(desc == "some failure", "failure message was '\(desc)'")
//        }

        XCTAssert(asdf.value() == 123, "value was \(asdf.value())")
        XCTAssert(funcWasCalled == false, "function was called")
    }


    func assertRGBA(rgba: (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat), isEqualTo t:(CGFloat, CGFloat, CGFloat, CGFloat)) {
        XCTAssertEqualWithAccuracy(rgba.r, CGFloat(t.0), 0.000001)
        XCTAssertEqualWithAccuracy(rgba.g, CGFloat(t.1), 0.000001)
        XCTAssertEqualWithAccuracy(rgba.b, CGFloat(t.2), 0.000001)
        XCTAssertEqualWithAccuracy(rgba.a, CGFloat(t.3), 0.000001)
    }

    func test_rgbaFromHexCode() {
        let color = rgbaFromHexCode("#ff0000")
        let norm  = color! |> normalizeRGBA(colors:255)
        NSLog("cccolor = \(color) (normalized = \(norm))")
        assertRGBA(norm, isEqualTo:(1, 0, 0, 1))
        assertRGBA(rgbaFromHexCode("#00ff00")! |> normalizeRGBA(colors:255), isEqualTo:(0, 1, 0, 1))
        assertRGBA(rgbaFromHexCode("#0000ff")! |> normalizeRGBA(colors:255), isEqualTo:(0, 0, 1, 1))

        assertRGBA(rgbaFromHexCode("#ff000000")! |> normalizeRGBA(colors:255), isEqualTo:(1, 0, 0, 0))
        assertRGBA(rgbaFromHexCode("#00ff00ff")! |> normalizeRGBA(colors:255), isEqualTo:(0, 1, 0, 1))
        assertRGBA(rgbaFromHexCode("#0000ff00")! |> normalizeRGBA(colors:255), isEqualTo:(0, 0, 1, 0))
    }

    func test_rgbaFromRGBAString() {
        assertRGBA(rgbaFromRGBAString("rgba(0.1, 0.9, 0.2, 0.9)")!, isEqualTo:(0.1, 0.9, 0.2, 0.9))
        assertRGBA(rgbaFromRGBAString("rgba(0.1,0.9,0.2,0.9)")!   , isEqualTo:(0.1, 0.9, 0.2, 0.9))
    }
}








