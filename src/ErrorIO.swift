//
//  Error.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


public protocol IErrorType
{
    var domain: String { get }
    var code: Int { get }
    var localizedDescription: String { get }

}

extension NSError: IErrorType {}


public struct ErrorIO
{
    public typealias Element = IErrorType
    public typealias UnderlyingCollection = [Element]

    public private(set) var errors = UnderlyingCollection()
    public var errorCount: Int { return errors.count }

    public var domain: String = "com.illumntr.MultiError"
    public var code:   Int    = 1

    public var localizedDescription: String {
        let localizedErrors = describe(errors) { $0.localizedDescription }
        return "<ErrorIO: errors = \(localizedErrors)>"
    }

    public init() {}

    public init(_ others: ErrorIO...)
    {
        for other in others {
            errors += other.errors
        }
    }

    public init(_ others: IErrorType...)
    {
        for other in others {
            errors.append(other)
        }
    }


    public static func defaultError(userInfo: [NSObject: AnyObject]) -> ErrorIO {
        return ErrorIO() <~ NSError(domain: "", code: 0, userInfo: userInfo)
    }

    public static func defaultError(message: String, file: String = __FILE__, line: Int = __LINE__) -> ErrorIO {
        let userInfo: [NSObject: AnyObject] = [
            NSLocalizedDescriptionKey: message,
            "file": file,
            "line": line,
        ]
        return defaultError(userInfo)
    }

    public static func defaultError(file: String = __FILE__, line: Int = __LINE__) -> ErrorIO {
        let userInfo: [NSObject: AnyObject] = [ "file": file, "line": line, ]
        return defaultError(userInfo)
    }

}


//-
// MARK: - Error: SequenceType
//__

extension ErrorIO: SequenceType
{
    public typealias Generator = GeneratorOf<Element>
    public func generate() -> Generator
    {
        var generator = errors.generate()
        return GeneratorOf { return generator.next() }
    }
}


//-
// MARK: - Error: CollectionType
//__

extension ErrorIO: CollectionType
{
    public typealias Index = UnderlyingCollection.Index
    public var startIndex : Index { return errors.startIndex }
    public var endIndex   : Index { return errors.endIndex }

    public subscript(position:Index) -> Generator.Element {
        return errors[position]
    }
}


//-
// MARK: - Error: ExtensibleCollectionType
//__

extension ErrorIO: ExtensibleCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        errors.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `push()`, included for `ExtensibleCollectionType` conformance.
     */
    public mutating func append(newElement:Element) {
        errors.append(newElement)
    }


    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public mutating func extend <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        errors.extend(sequence)
    }
}


//-
// MARK: - Error: ArrayLiteralConvertible
//__

extension ErrorIO: ArrayLiteralConvertible
{
    public init(arrayLiteral errors: Element...) {
        extend(errors)
    }
}



//-
