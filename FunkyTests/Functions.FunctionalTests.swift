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
        describe("toCollection()") {
            it("should collect the elements of a finite sequence into a collection in the order that they were generated") {
                let seq = SequenceOf([5, 4, 3, 2, 1])
                let collected: [Int] = seq |> toCollection
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
                let areEqual = equalSequences(zipped |> toArray, expected, equalTuples)
                expect(areEqual) == true

            }
        }
        
        describe("take(Int)(SequenceType)") {
            it("should take n elements of the provided sequence, even if the sequence is infinite") {
                var gen = GeneratorOf { "xyzzy" }
                let arr = GeneratorSequence(gen) |> take(5) |> toArray
                expect(arr.count) == 5
                expect(arr[0]) == "xyzzy"
                expect(arr[4]) == "xyzzy"
            }
        }
        
        describe("setValueForKeypath()") {
            it("should set a value in a nested tree of string-keyed dictionaries") {
                let dict = [
                    "an object": [
                        "one": 111,
                        "two": 222,
                        "three": 333,
                    ]
                ]
                
                let maybeChanged = setValueForKeypath(dict, ["an object", "two"], Int(5432))
                
                expect(maybeChanged.isSuccess).to(beTrue())
                expect(maybeChanged.value).toNot(beNil())
                
                let changed = maybeChanged.value!
                if let anObject = changed["an object"] as? [String: AnyObject]
                {
                    if let value = anObject["two"] as? Int {
                        expect(value) == 5432
                    }
                    else { expect(1).to(equal(2)) } // there's gotta be a better way to do this
                }
                else { expect(1).to(equal(2)) }
            }
        }
    }
}

