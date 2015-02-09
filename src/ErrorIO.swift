//
//  ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit

func formatError(error:NSError) -> String
{
    if let errorIO = error as? ErrorIO {
        return errorIO.localizedDescription
    }
    else {
        if let (file, line) = both(error.userInfo?["file"] as? String, error.userInfo?["line"] as? Int) {
            return "[\(file) : \(line)] \(error.localizedDescription)"
        }
        return "\(error.localizedDescription)"
    }
}


/**
    The primary purpose of `ErrorIO` (a subclass of `NSError`) is to attempt to standardize a
    method for coalescing multiple errors.  For example, a task with multiple subtasks might
    return a `Result<T>` the error type of which is an `ErrorIO` containing multiple errors
    from multiple failed subtasks.  `ErrorIO` implements `SequenceType`, `CollectionType`,
    `ExtensibleCollectionType`, and `ArrayLiteralConvertible`.
 */
public class ErrorIO: NSError
{
    public struct Constants {
        public static let FileKey = "__file__"
        public static let LineKey = "__line__"
    }
    
    public class var defaultDomain: String { return "com.illumntr.ErrorIO" }
    public class var defaultCode:   Int    { return 1 }

    public typealias Element = NSError
    public typealias UnderlyingCollection = [Element]

    public private(set) var errors = UnderlyingCollection()

    override public var localizedDescription: String {
        let localizedErrors = describe(errors) { formatError($0) |> indent }
        return "<ErrorIO: errors = \(localizedErrors)>"
    }

    required public init() {
        super.init(domain: ErrorIO.defaultDomain, code:ErrorIO.defaultCode, userInfo:nil)
    }

    convenience public init(flatten others: ErrorIO...)
    {
        self.init()
        for other in others {
            errors += other.errors
        }
    }

    convenience public init(with others: NSError...)
    {
        self.init()
        for other in others {
            errors.append(other)
        }
    }

    convenience required
    public init(arrayLiteral errors: Element...) {
        self.init()
        extend(errors)
    }

    public class func defaultError(userInfo: [NSObject: AnyObject]) -> ErrorIO {
        return ErrorIO() <~ NSError(domain: ErrorIO.defaultDomain, code: ErrorIO.defaultCode, userInfo: userInfo)
    }

    public class func defaultError(message: String, file: String = __FILE__, line: Int = __LINE__) -> ErrorIO
    {
        let userInfo: [NSObject: AnyObject] = [
            NSLocalizedDescriptionKey: message,
            Constants.FileKey:         file,
            Constants.LineKey:         line,
        ]
        return defaultError(userInfo)
    }

    public class func defaultError(file: String = __FILE__, line: Int = __LINE__) -> ErrorIO {
        let userInfo: [NSObject: AnyObject] = [ Constants.FileKey: file, Constants.LineKey: line, ]
        return defaultError(userInfo)
    }

    required public init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
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
    public func reserveCapacity(n: Index.Distance) {
        errors.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `push()`, included for `ExtensibleCollectionType` conformance.
     */
    public func append(newElement:Element) {
        errors.append(newElement)
    }


    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public func extend <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        errors.extend(sequence)
    }
}


//-
// MARK: - Error: ArrayLiteralConvertible
//__

extension ErrorIO: ArrayLiteralConvertible {
}



//-
