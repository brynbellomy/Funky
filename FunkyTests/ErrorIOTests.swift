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


class ErrorIOTests: QuickSpec
{
    override func spec()
    {
        describe("an ErrorIO") {
            describe("newly initialized") {
                let err = ErrorIO()

                it("should contain no child errors") {
                    expect(equal(err.errors, [])).to(beTrue())
                }
            }

            describe("initialized with an array of NSErrors") {
                let err = ErrorIO(with:NSError(), NSError())

                it("should add the errors to errors") {
                    expect(err.errors.count) == 2
                }
            }

            describe("initialized with an array of ErrorIOs") {
                let err1 = ErrorIO(with:NSError(), NSError())
                let err2 = ErrorIO(with:NSError())

                let err = ErrorIO(flatten:err1, err2)

                it("should add the errors of each ErrorIO to errors") {
                    expect(err.errors.count) == 3
                }
            }


            describe("initialized with an array literal of NSErrors") {
                let err: ErrorIO = [ NSError(), NSError() ]

                it("should add the errors to errors") {
                    expect(err.errors.count) == 2
                }
            }


            describe("when individual NSErrors are added to it with the <~ operator") {
                var err = ErrorIO()
                err <~ NSError()
                err <~ NSError()

                it("should add them to errors") {
                    expect(err.errors.count) == 2
                }
            }
        }
    }
}

