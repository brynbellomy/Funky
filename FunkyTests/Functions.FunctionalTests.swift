//
//  Functions.FunctionalTests.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 15.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Funky



class FunctionsFunctionalTests: QuickSpec
{
    override func spec()
    {
        describe("collect()") {
            it("should collect the elements of a finite sequence into a collection in the order that they were generated") {
                let seq = SequenceOf([5, 4, 3, 2, 1])
                let collected = collect(seq) as [Int]
                expect(collected) == [5, 4, 3, 2, 1]
            }
        }

        describe("partition()") {
            it("should collect a sequence and split its elements into two arrays based on the return value of predicate(elem)") {
                let arr = [1, 2, 3, 4, 5, 6, 7, 8]
                let (passing, failing) = arr |> partition { $0 % 2 == 0 }
                expect(passing) == [2, 4, 6, 8]
                expect(failing) == [1, 3, 5, 7]
            }
        }

        describe("zipseq()") {
            it("should zip sequences A and B into a sequence of tuples (elementA, elementB)") {
                let one = SequenceOf([2, 4, 6, 8])
                let two = SequenceOf([20, 40, 60, 80])
                let zipped = zipseq(one, two)
                let expected = [(2, 20), (4, 40), (6, 60), (8, 80)]
                let areEqual = equal(zipped, expected, equal)
                expect(areEqual) == true

            }
        }
    }
}

