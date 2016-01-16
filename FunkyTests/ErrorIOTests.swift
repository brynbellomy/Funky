//
//  ErrorIOTests.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 15.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Funky

enum TestError : ErrorType {
    case Error
}

class ErrorIOTests: QuickSpec
{
    override func spec()
    {
        describe("an ErrorIO") {
            describe("newly initialized") {
                let err = ErrorIO()

                it("should contain no child errors") {
                    expect(err.errors.count) == 0
                }
            }

            
            describe("initialized with an array literal of NSErrors") {
                let err: ErrorIO = [ TestError.Error, TestError.Error ]

                it("should add the errors to errors") {
                    expect(err.errors.count) == 2
                }
            }


            describe("when individual NSErrors are added to it with the <~ operator") {
                let err = ErrorIO()
                err <~ NSError(domain: "", code: 0, userInfo: nil)
                err <~ NSError(domain: "", code: 0, userInfo: nil)

                it("should add them to errors") {
                    expect(err.errors.count) == 2
                }
            }
            
            describe("when individual Strings are added to it with the <~ operator") {
                let err = ErrorIO()
                err <~ "some error"
                err <~ "some other error"

                it("should add them to errors") {
                    expect(err.errors.count) == 2
                }
            }
        }
    }
}

