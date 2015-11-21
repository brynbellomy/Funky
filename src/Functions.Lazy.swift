//
//  Functions.Lazy.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jun 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

public struct Lazy
{
    public static func partition <S: SequenceType>
        (seq: S, predicate: S.Generator.Element -> Bool)
            -> (LazySequence<SequenceOf<S.Generator.Element>>, LazySequence<SequenceOf<S.Generator.Element>>)
    {
        let pass = lazy(seq).filter { predicate($0) == true } .map { $0 }
pass
        let fail = lazy(seq).filter { predicate($0) == false }
        return (lazy(SequenceOf(pass)), lazy(SequenceOf(fail)))
    }

    
    /**
        Decomposes a `Dictionary` into a lazy sequence of key-value tuples.
     */
    public static func pairs <K: Hashable, V>
        (dict:[K: V]) -> LazySequence<SequenceOf<(K, V)>>
    {
        var gen = lazy(dict).map(id).generate()
        return lazy(SequenceOf(gen))
    }


    public static func selectWhere <S: SequenceType>
        (predicate: S.Generator.Element -> Bool) (seq: S) -> LazySequence<SequenceOf<S.Generator.Element>>
    {
        return lazy(SequenceOf(lazy(seq).filter(predicate)))
    }


}

