////
////  NSError+Coalescing.swift
////  Funky
////
////  Created by bryn austin bellomy on 2014 Dec 9.
////  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
////
//
//
//public extension NSError
//{
//    public var isMultiError : Bool {
//        return (userInfo?["is multi error"] as? Bool) ?? false
//    }
//
//    public var errors : [NSError] {
//        return (userInfo?["errors"] as? [NSError]) ?? []
//    }
//
//    public class func multiError(errors:[NSError]) -> NSError {
//        return NSError(domain:"com.illumntr.multi-error", code:1, userInfo: ["isMultiError": true, "errors" : errors])
//    }
//
//    public var multiErrorDescription : String {
//        if isMultiError {
//            let strings = map(enumerate(errors)) { "\($0.0). \($0.1.localizedDescription)" }
//            return join("\n", strings)
//        }
//        else { return localizedDescription }
//    }
//
//
//    public class func coalesceErrors(errors:[NSError]) -> NSError
//    {
//        var flattenedErrors = [NSError]()
//
//        for error in errors {
//            error.isMultiError ? flattenedErrors.extend(error.errors)
//                               : flattenedErrors.append(error)
//        }
//
//        first.isMultiError  ? flattenedErrors.extend(first.errors)
//                           : flattenedErrors.append(first)
//
//        other.isMultiError ? flattenedErrors.extend(other.errors)
//                           : flattenedErrors.append(other)
//
//        return NSError.multiError(flattenedErrors)
//    }
//
//
//    public func coalesceWithError(other:NSError) -> NSError {
//        return NSError.coalesceErrors(self, other:other)
//    }
//}
//
//
