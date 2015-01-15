//
//  Functions.ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


public func failure <T> (message: String, file: String = __FILE__, line: Int = __LINE__) -> Result<T, ErrorIO>
{
    let userInfo: [NSObject: AnyObject] = [
        NSLocalizedDescriptionKey: message,
        "file": file,
        "line": line,
    ]
    return failure(ErrorIO.defaultError(userInfo))
}


public func failure <T> (error: NSError) -> Result<T, ErrorIO> {
    return failure(ErrorIO() <~ error)
}


public func failure <T> (file: String = __FILE__, line: Int = __LINE__) -> Result<T, ErrorIO> {
    return failure("", file: file, line: line)
}



