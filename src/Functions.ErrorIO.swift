//
//  Functions.ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


public func coalesce <T> (arr:[Result<T>]) -> Result<[T]>
{
    let failures = selectFailures(arr)
    if failures.count > 0 {
        let errorIO = failures.reduce(ErrorIO(), combine: <~)
        return failure(errorIO)
    }
    else {
        return success(rejectFailures(arr))
    }
}

public func coalesce2 <T, U> (arr:[(Result<T>, Result<U>)]) -> Result<[(T, U)]>
{
    let errorIO = arr |> reducer(ErrorIO()) { (var into, each) in
        let (left, right) = each

        if let error = left.error()  { into <~ error }
        if let error = right.error() { into <~ error }
        return into
    }

    if errorIO.errors.count > 0 {
        return failure(errorIO)
    }
    else {
        return arr  |> map‡ { ($0.0.value()!, $0.1.value()!) }
                    |> success
    }
}


public func failure <T> (message: String, file: String = __FILE__, line: Int = __LINE__) -> Result<T> {
    return failure(ErrorIO.defaultError(message, file:file, line:line))
}


//public func failure <T> (file: String = __FILE__, line: Int = __LINE__) -> Result<T> {
//    return failure("", file: file, line: line)
//}



