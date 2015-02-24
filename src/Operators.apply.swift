//
//  Operators.apply.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit


/**
    apply operator (applicative functors) ((A -> B)?  <|  A?)
 */
infix operator <*> { associativity left precedence 101 }


public func <*>
    <A, B>
    (f: (A -> B)?, maybeValue: A?) -> B?
{
    switch f
    {
        case .Some(let fx): return fx <^> maybeValue
        case .None: return .None
    }
}


public func <*>
    <A, B, E>
    (f: Result<A -> B, E>, values: Result<A, E>) -> Result<B, E>
{
    return f.flatMap { fn in values.flatMap(fn >>> success) }
}

