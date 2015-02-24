//
//  Functions.Functional.swift
//  Funky
//
//  Created by bryn austin bellomy on 2014 Dec 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit


/**
    The identity function.  Returns its argument.  
 */
public func id <T> (arg:T) -> T {
    return arg
}


/**
    Returns the first element of `collection` or `nil` if `collection` is empty.
 */
public func head <C: CollectionType>
    (collection: C) -> C.Generator.Element?
{
    if count(collection) > 0 {
        return collection[collection.startIndex]
    }
    return nil
}


/**
    Returns a collection containing all but the first element of `collection`.
 */
public func tail
    <C: CollectionType, D: ExtensibleCollectionType where C.Generator.Element == D.Generator.Element>
    (collection: C) -> D
{
    return tail(collection, collection.startIndex.successor())
}


/**
    Returns a collection containing all but the first `n` elements of `collection`.
 */
public func tail
    <C: CollectionType, D: ExtensibleCollectionType where C.Generator.Element == D.Generator.Element>
    (collection: C, n: C.Index) -> D
{
    var theTail = D()
    let end = collection.endIndex
    for i in n ..< collection.endIndex {
        theTail.append(collection[i])
    }
    return theTail
}


/**
    Collects a sequence (`SequenceType`) into a collection (`ExtensibleCollectionType`).  The
    specific type of the returned collection must be stated explicitly.  For example:  
    `let array: [String] = stringSequence |> collect`
 */
public func collect
    <S: SequenceType, D: ExtensibleCollectionType where S.Generator.Element == D.Generator.Element>
    (seq:S) -> D
{
    var gen = seq.generate()

    var collected = D()
    while let current = gen.next() {
        collected.append(current)
    }
    return collected
}


/**
    Simply calls `Array(collection)` — however, because constructors cannot be applied like
    normal functions, this is more convenient in functional pipelines.
 */
public func toArray <C: CollectionType>
    (collection:C) -> [C.Generator.Element]
{
    return Array(collection)
}


/**
    Simply calls `Set(collection)` — however, because constructors cannot be applied like
    normal functions, this is more convenient in functional pipelines.
 */
public func toSet <C: CollectionType>
    (collection:C) -> Set<C.Generator.Element>
{
    return Set(collection)
}


/**
    Returns `true` iff `one.0` == `two.0` and `one.1` == `two.1`.
 */
public func equal <T: Equatable, U: Equatable>
    (one: (T, U), two: (T, U)) -> Bool
{
    return one.0 == two.0 && one.1 == two.1
}


/**
    Returns `true` iff the corresponding elements of sequences `one` and `two` all satisfy
    the provided `equality` predicate.
 */
public func equal <S: SequenceType, T: SequenceType>
    (one:S, two:T, equality:(S.Generator.Element, T.Generator.Element) -> Bool) -> Bool
{
    var gen1 = one.generate()
    var gen2 = two.generate()

    while true
    {
        let (left, right) = (gen1.next(), gen2.next())

        if left == nil && right == nil                                            { return true  }
        else if (left == nil) || (right == nil) && !(left == nil && right == nil) { return false }
        else if equality(left!, right!) == false                                  { return false }
        else { continue }
    }
}


/**
    If both of the arguments passed to `both()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func both <T, U>
    (one:T?, two:U?) -> (T, U)?
{
    if let one = one, two = two {
        return (one, two)
    }
    return nil
}


/**
    If any of the elements of `seq` satisfy `predicate`, `any()` returns `true`.  Otherwise, it
    returns `false`.
*/
public func any <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == true {
            return true
        }
    }
    return false
}


/**
    If all of the elements of `seq` satisfy `predicate`, `all()` returns `true`.  Otherwise,
    it returns `false`.
*/
public func all <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == false {
            return false
        }
    }
    return true
}


/**
    If all of the arguments passed to `all()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func all
    <T, U, V>
    (one:T?, two:U?, three:V?) -> (T, U, V)?
{
    if let one = one, two = two, three = three {
        return (one, two, three)
    }
    return nil
}


/**
    If all of the arguments passed to `all()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func all
    <T, U, V, W>
    (one:T?, two:U?, three:V?, four:W?) -> (T, U, V, W)?
{
    if let one = one, two = two, three = three, four = four {
        return (one, two, three, four)
    }
    return nil
}


/**
    This function simply calls `result.isSuccess()` but is more convenient in functional pipelines.
 */
public func isSuccess <T, E> (result:Result<T, E>) -> Bool {
    return result.isSuccess
}


/**
    This function simply calls `!result.isSuccess()` but is more convenient in functional pipelines.
 */
public func isFailure <T, E> (result:Result<T, E>) -> Bool {
    return !isSuccess(result)
}


/**
    This function simply calls `result.value()` but is more convenient in functional pipelines.
 */
public func unwrapValue <T, E> (result: Result<T, E>) -> T? {
    return result.value
}


/**
    This function simply calls `result.error()` but is more convenient in functional pipelines.
 */
public func unwrapError <T, E> (result: Result<T, E>) -> E? {
    return result.error
}


/**
    Curried function that returns its arguments zipped together into a 2-tuple.
 */
public func zip2 <T, U> (one:T) (two:U) -> (T, U) {
    return (one, two)
}


/**
    Curried function that returns its arguments zipped together into a 3-tuple.
 */
public func zip3 <T, U, V>  (one:T) (two:U) (three:V) -> (T, U, V) {
    return (one, two, three)
}


public func zipseq
    <S: SequenceType, T: SequenceType>
    (one:S, two:T) -> SequenceOf<(S.Generator.Element, T.Generator.Element)>
{
    return ZipGenerator2(one.generate(), two.generate())
                |> unfold {
                    var y = $0
                    if let elem = y.next() {
                        return (elem, y)
                    }
                    return nil
                }
}


// @@TODO: find a place to use this and see if it works (or just test `zipseq`, which uses it)
public func unfold <T, U>
    (closure: T -> (U, T)?) (initial:T) -> SequenceOf<U>
{
    var arr = [U]()
    var current = initial
    while let (created, next) = closure(current) {
        current = next
        arr.append(created)
    }

    return SequenceOf(arr)
}


//
//-- | The 'partition' function takes a predicate a list and returns
//-- the pair of lists of elements which do and do not satisfy the
//-- predicate, respectively; i.e.,
//--
//-- > partition p xs == (filter p xs, filter (not . p) xs)
//
//partition               :: (a -> Bool) -> [a] -> ([a],[a])
//{-# INLINE partition #-}
//partition p xs = foldr (select p) ([],[]) xs
//

public func partition
    <S: SequenceType, T where T == S.Generator.Element>
    (predicate:T -> Bool) (seq:S) -> ([T], [T])
{
    let start = ([T](), [T]())

    return seq |> reducer(start) { (var into, each) in
                      if predicate(each) {
                          into.0.append(each)
                      }
                      else {
                          into.1.append(each)
                      }
                      return into
                  }
}


/**
    Returns `true` iff `range` contains only valid indices of `collection`.
 */
public func contains
    <I: Comparable, C: CollectionType where I == C.Index>
    (collection: C, range: Range<I>) -> Bool
{
    let interval: HalfOpenInterval = collection.startIndex ..< collection.endIndex
    return interval ~= range.startIndex && interval ~= range.endIndex
}


/**
    Applies `transform` to the first element of `tuple` and returns the resulting tuple.
 */
public func mapLeft1
    <T, U, V>
    (transform:T -> V) (tuple:(T, U)) -> (V, U)
{
    return (transform(tuple.0), tuple.1)
}


/**
    Applies `transform` to the key of each element of `dict` and returns the resulting
    sequence of key-value tuples as an `Array`.  If you need a dictionary instead of a
    tuple array, simply pass the return value of this function through `mapDictionary { $0 }`.
 */
public func mapLeft <T, U, V> (transform: T -> V) (dict:[T: U]) -> [(V, U)] {
    return map(dict, mapLeft1(transform))
}


/**
    Applies `transform` to the first (`0`th) element of each tuple in `seq` and returns the
    resulting `Array` of tuples.
 */
public func mapLeft <T, U, V> (transform: T -> V) (seq:[(T, U)]) -> [(V, U)] {
    return map(seq, mapLeft1(transform))
}


public func mapRight1 <T, U, V> (transform:U -> V) (tuple:(T, U)) -> (T, V) {
    return (tuple.0, transform(tuple.1))
}


/**
    Applies `transform` to the value of each key-value pair in `dict`, transforms the pairs into
    tuples, and returns the resulting `Array` of tuples.
 */
public func mapRight
    <T, U, V>
    (transform: U -> V) (dict:[T: U]) -> [(T, V)]
{
    return map(dict, mapRight1(transform))
}


/**
    Applies `transform` to the second element of each 2-tuple in `seq` and returns the resulting
    `Array` of tuples.
 */
public func mapRight
    <T, U, V>
    (transform: U -> V) (seq:[(T, U)]) -> [(T, V)]
{
    return map(seq, mapRight1(transform))
}


public func mapKeys
    <T, U, V>
    (transform: T -> V) (dict:[T: U]) -> [V: U]
{
    return mapLeft(transform)(dict:dict)
        |> mapToDictionary(id)
}


public func mapValues
    <T, U, V>
    (transform: U -> V) (dict:[T: U]) -> [T: V]
{
    return mapRight(transform)(dict:dict)
        |> mapToDictionary(id)
}


public func makeLeft <T, U>
    (transform:T -> U) (value:T) -> (U, T)
{
    return (transform(value), value)
}


public func makeRight <T, U>
    (transform:T -> U) (value:T) -> (T, U)
{
    return (value, transform(value))
}


public func takeLeft <T, U>
    (tuple: (T, U)) -> T
{
    return tuple.0
}


public func takeRight <T, U>
    (tuple: (T, U)) -> U
{
    return tuple.1
}


public func takeFirst
    <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq:S) -> S.Generator.Element?
{
    for item in seq {
        if predicate(item) {
            return item
        }
    }
    return nil
}


public func takeWhile
    <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> [S.Generator.Element]
{
    var taken = Array<S.Generator.Element>()
    for item in seq
    {
        if predicate(item) == true {
            taken.append(item)
        }
        else { break }
    }
    return taken
}


public func selectFailures <T, E>
    (array:[Result<T, E>]) -> [E]
{
    return array |> mapFilter { $0.error }
}


public func rejectFailures <T, E>
    (source: [Result<T, E>]) -> [T]
{
    return source |> rejectIf({ !$0.isSuccess })
                  |> mapFilter(unwrapValue)
}


public func rejectFailuresAndDispose <T, E>
    (disposal:E -> Void) (source: [Result<T, E>]) -> [T]
{
    return source |> rejectIfAndDispose({ !isSuccess($0) })({ disposal($0.error!) })
                  |> mapFilter(unwrapValue)
}


public func groupBy
    <K: Hashable, V, S: SequenceType where S.Generator.Element == V>
    (keyClosure:V -> K) (seq:S) -> [K: [V]]
{
    return reduce(seq, [K: [V]]()) { (var current, next) in
        let key: K = keyClosure(next)
        if current[key] == nil { current[key] = [V]() }
        current[key]!.append(next)
        return current
    }
}


/**
    Argument-reversed, curried version of `reduce()`.
 */
public func reducer
    <S: SequenceType, U>
    (initial:U, combine: (U, S.Generator.Element) -> U) (seq:S) -> U
{
    return reduce(seq, initial, combine)
}


/**
    Argument-reversed, curried version of `split()`.
 */
public func splitOn
    <S: Sliceable where S.Generator.Element: Equatable>
    (separator: S.Generator.Element) (collection: S) -> [S.SubSlice]
{
    return split(collection, { $0 == separator })
}


/**
    Curried version of `join()`.
 */
public func joinWith
    <C: ExtensibleCollectionType, S: SequenceType where S.Generator.Element == C>
    (separator: C) (elements: S) -> C
{
    return join(separator, elements)
}


/**
    Returns an array containing only the unique elements of `seq`.
 */
public func unique
    <S: SequenceType where S.Generator.Element: Hashable>
    (seq:S) -> [S.Generator.Element]
{
    var dict = Dictionary<S.Generator.Element, Bool>()
    for item in seq {
        dict[item] = true
    }
    return Array(dict.keys)
}


/**
    Decomposes a `Dictionary` into an `Array` of key-value tuples.
 */
public func pairs
    <K: Hashable, V>
    (dict:[K: V]) -> [(K, V)]
{
    return map(dict, id)
}


/**
    Curries a binary function.
 */
public func curry <A, B, R>
    (f: (A, B) -> R) -> A -> B -> R
{
    return { x in { y in f(x, y) }}
}


/**
    Curries a ternary function.
 */
public func curry <A, B, C, R>
    (f: (A, B, C) -> R) -> A -> B -> C -> R
{
    return { a in { b in { c in f(a, b, c) } } }
}


/**
    Curries a binary function and swaps the placement of the arguments.  Useful for
    bringing the Swift built-in collection functions into functional pipelines.  For
    example: `someArray |> currySwap(map)({ $0 ... })`.  See also the `‡` operator,
    which is equivalent and more concise (i.e., `someArray |> map‡ { $0 ... })`).
 */
public func currySwap
    <T, U, V>
    (f: (T, U) -> V) -> U -> T -> V
{
    return { x in { y in f(y, x) }}
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T: AnyObject> (val:T?) -> Bool {
    return val === nil
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T: NilLiteralConvertible> (val:T?) -> Bool {
    return val == nil
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T> (val:T?) -> Bool
{
    switch val {
        case .Some(let _): return true
        case .None:        return false
    }
}


/**
    Returns `true` if `value` is non-`nil`, `false` otherwise.
 */
public func nonNil <T> (value:T?) -> Bool {
    if let value = value {
        return true
    }
    return false
}


/**
    Curried function that maps a transform function over a given object and
    returns a 2-tuple of the form `(object, transformedObject)`.
 */
public func zipMap <T, U>
    (transform: T -> U) (object: T) -> (T, U)
{
    let transformed = transform(object)
    return (object, transformed)
}


/**
    Curried function that maps `transform` over `object` and returns an unlabeled 2-tuple of the
    form `(transformedObject, object)`.
 */
public func zipMapLeft
    <T, U>
    (transform: T -> U) (object: T) -> (U, T)
{
    let transformed = transform(object)
    return (transformed, object)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an array
    of 2-tuples of the form `(object, transformedObject)`.  If `transform` returns `nil` for a given
    element in the collection, the tuple for that element will not be included in the returned `Array`.
 */
public func zipFilter
    <C: CollectionType, T>
    (transform: C.Generator.Element -> T?) (source: C) -> [(C.Generator.Element, T)]
{
    let zipped_or_nil : (C.Generator.Element) -> (C.Generator.Element, T)? = zipFilter(transform)
    return source |> mapFilter(zipped_or_nil)
}


/**
    Curried function that maps a transform function over a given object and returns an `Optional` 2-tuple
    of the form `(object, transformedObject)`.  If `transform` returns `nil`, this function will also
    return `nil`.
 */
public func zipFilter <T, U> (transform: T -> U?) (object: T) -> (T, U)?
{
    if let transformed = transform(object) {
        return (object, transformed)
    }
    else { return nil }
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of
    2-tuples of the form `(object, transformedObject)`.
 */
public func zipMap <C: CollectionType, T> (transform: C.Generator.Element -> T) (source: C) -> [(C.Generator.Element, T)] {
    let theZip = zipMap(transform)
    return map(source, theZip)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of
    2-tuples of the form `(object, transformedObject)`.
 */
public func zipMapLeft <C: CollectionType, T> (transform: C.Generator.Element -> T) (source: C) -> [(T, C.Generator.Element)] {
    let theZip = zipMapLeft(transform)
    return map(source, theZip)
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.  The return type
    must be explicitly specified, as this function is capable of returning any `ExtensibleCollectionType`.

    :returns: A collection of type `D` containing the elements of `seq` that satisfied `predicate`.
 */
public func selectWhere
    <S: SequenceType, D: ExtensibleCollectionType where S.Generator.Element == D.Generator.Element>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> D
{
    var keepers = D()
    for item in seq {
        if predicate(item) == true {
            keepers.append(item)
        }
    }
    return keepers
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.

    :returns: An `Array` containing the elements of `seq` that satisfied `predicate`.
 */
public func selectArray <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Array<S.Generator.Element>
{
    return selectWhere(predicate)(seq:seq)
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.
 */
public func selectWhere <K, V> (predicate: (K, V) -> Bool) (dict: [K: V]) -> [K: V] {
    let arr: [(K, V)] = dict |> pairs |> selectWhere(predicate)
    return arr |> mapToDictionary(id)
}


/**
    A curried, argument-reversed version of `map` for use in functional pipelines.  For example:  

    `let descriptions = someCollection |> mapr { $0.description }`

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The transformed collection.
 */
public func mapr
    <S: SequenceType, T>
    (transform: S.Generator.Element -> T) (source: S) -> [T]
{
    return map(source, transform)
}


/**
    A curried, argument-reversed version of `map` for use in functional pipelines.  `mapTo` is capable
    of returning the resulting mapped collection as any `ExtensibleCollectionType`.  The return type
    must therefore always be explicitly specified.  For example:  

    `let descriptions: [String] = someCollection |> mapr { $0.description }`

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The transformed collection.
 */
public func mapTo
    <S: SequenceType, D: ExtensibleCollectionType>
    (transform: S.Generator.Element -> D.Generator.Element) (source: S) -> D
{
    var mapped = D()
    for item in source {
        mapped.append(transform(item))
    }
    return mapped
}


/**
    Curried function that maps a transform function over a sequence and filters nil values from the
    resulting collection before returning it.  Note that you must specify the generic parameter `D`
    (the return type) explicitly.  Small pain in the ass for the lazy, but it lets you ask for any
    kind of `ExtensibleCollectionType` that you could possibly want.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `ExtensibleCollectionType` of your choosing.
 */
public func mapFilter
    <S: SequenceType, D: ExtensibleCollectionType>
    (transform: S.Generator.Element -> D.Generator.Element?) (source: S) -> D
{
    var result = D()
    for x in source {
        if let y = transform(x) {
            result.append(y)
        }
    }
    return result
}


/**
    Curried function that maps a transform function over a sequence and filters `nil` values
    from the resulting `Array` before returning it.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `Array` with the mapped, non-nil values from the input sequence.
 */
public func mapFilter
    <S: SequenceType, T>
    (transform: S.Generator.Element -> T?) (source: S) -> [T]
{
    var result = [T]()
    for x in source {
        if let mapped = transform(x) {
            result.append(mapped)
        }
    }
    return result
}


/**
    Curried function that rejects elements from `source` if they satisfy `predicate`.  The
    filtered sequence is returned as an `Array`. 
 */
public func rejectIf
    <S: SequenceType, T where S.Generator.Element == T>
    (predicate:T -> Bool) (source: S) -> [T]
{
    var results = [T]()
    for x in source
    {
        if !predicate(x) {
            results.append(x)
        }
    }
    return results
}


/**
    Curried function that rejects values from `source` if they satisfy `predicate`.  Any
    time a value is rejected, `disposal(value)` is called.  The filtered sequence is
    returned as an `Array`.  This function is mainly useful for logging failures in
    functional pipelines.

    :param: predicate The predicate closure to which each sequence element is passed.
    :param: disposal The disposal closure that is invoked with each rejected element.
    :param: source The sequence to filter.
    :returns: The filtered sequence as an `Array`.
 */
public func rejectIfAndDispose
    <S: SequenceType, T where S.Generator.Element == T>
    (predicate:T -> Bool) (_ disposal:T -> Void) (source: S) -> [T]
{
    var results = [T]()
    for x in source
    {
        if !predicate(x) {
            results.append(x)
        }
        else {
            disposal(x)
        }
    }
    return results
}


/**
    A curried, argument-reversed version of `each` used to create side-effects in functional
    pipelines.  Note that it returns the collection, `source`, unmodified.  This is to facilitate
    fluent chaining of such pipelines.  For example:

    <pre>
    someCollection |> doEach { println("the object is \($0)") }
                   |> map‡    { $0.description }
                   |> doEach { println("the object's description is \($0)") }
    </pre>

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The collection, unmodified.
 */
public func doEach
    <S: SequenceType, T>
    (closure: S.Generator.Element -> T) (source: S) -> S
{
    for item in source {
        closure(item)
    }
    return source
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide
    <T, X>
    (closure: T -> X) (data: T) -> T
{
    closure(data)
    return data
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide2
    <T, U, X>
    (closure: (T, U) -> X) (one:T, two:U) -> (T, U)
{
    closure(one, two)
    return (one, two)
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide3
    <T, U, V, X>
    (closure: (T, U, V) -> X) (one:T, two:U, three:V) -> (T, U, V)
{
    closure(one, two, three)
    return (one, two, three)
}


/**
    Rejects nil elements from the provided collection.

    :param: collection The collection to filter.
    :returns: The collection with all `nil` elements removed.
*/
public func rejectNil
    <T>
    (collection: [T?]) -> [T]
{
    var nonNilValues = [T]()
    for item in collection
    {
        if nonNil(item) {
            nonNilValues.append(item!)
        }
    }
    return nonNilValues
}


/**
    Returns `nil` if either value in the provided 2-tuple is `nil`.  Otherwise, returns the input tuple with
    its inner `Optional`s flattened (in other words, the returned tuple is guaranteed by the type-checker to
    have non-`nil` elements).  Another way to think about `rejectEitherNil` is that it is a logical transform
    that moves the `?` (`Optional` unary operator) from inside the tuple braces to the outside.

    :param: tuple The tuple to examine.
    :returns: The tuple or nil.
*/
public func rejectEitherNil
    <T, U>
    (tuple: (T?, U?)) -> (T, U)?
{
    if let zero = tuple.0, one = tuple.1 {
        return (zero, one)
    }
    return nil
}


/**
    Rejects tuple elements from the provided collection if either value in the tuple is `nil`.  This is often
    useful when handling the results of multiple subtasks when those results are provided as a `Dictionary`.
    Such a `Dictionary` can be passed through `pairs()` to create a sequence of key-value tuples that this
    function can be `mapFilter`ed over.

    :param: collection The collection to filter.
    :returns: The provided collection with all tuples containing a `nil` element removed.
*/
public func rejectEitherNil
    <T, U>
    (collection: [(T?, U?)]) -> [(T, U)]
{
    return reduce(collection, Array<(T, U)>()) { (var nonNilValues, item) in
        if nonNil(item.0) && nonNil(item.1) {
            nonNilValues.append((item.0!, item.1!))
        }
        return nonNilValues
    }
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionaryKeys
    <K: Hashable, S: SequenceType>
    (keySelector:S.Generator.Element -> K) (seq:S) -> [K: S.Generator.Element]
{
    var result: [K: S.Generator.Element] = [:]
    for item in seq {
        result[keySelector(item)] = item
    }
    return result
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionary
    <K: Hashable, V, S: SequenceType>
    (transform: S.Generator.Element -> (K, V)) (seq: S) -> [K: V]
{
    var result: [K: V] = [:]
    for item in seq {
        let (key, value) = transform(item)
        result[key] = value
    }
    return result
}


/**
    Iterates through `domain` and returns the index of the first element for which `predicate(element)` returns `true`.

    :param: domain The collection to search.
    :returns: The index of the first matching item,  or `nil` if none was found.
 */
public func findWhere
    <C: CollectionType>
    (domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex: C.Index? = domain.startIndex
    do
    {
        if let index = maybeIndex
        {
            let item = domain[index]
            if predicate(item) {
                return index
            }

            maybeIndex = index.successor()
        }

    } while maybeIndex != nil

    return nil
}



//
// got this from http://www.objc.io/snippets/
// @@TODO: document
//

/**
    Decomposes `array` into a 2-tuple whose `head` property is the first element of `array` and
    whose `tail` property is an array containing all but the first element of `array`.  If
    `array.count == 0`, this function returns `nil`.
 */
public func decompose <T>
    (array:[T]) -> (head: T, tail: [T])?
{
    let theTail = array[1 ..< array.count]
    if array.count > 0 {
        return (array.first!, tail(array, 1))
    }
    return nil
}


/**
    Attempts to descend through a nested tree of `Dictionary` objects to the value represented
    by `keypath`.
 */
public func valueForKeypath <K: Hashable, V>
    (dictionary:[K: V], keypath:[K]) -> V?
{
    let currentKey = keypath[0]
    if let currentValue = dictionary[currentKey]
    {
        if keypath.count == 1 {
            return currentValue
        }
        else {
            if let innerDict = currentValue as? [K: V] {
                let newKeypath = Array(keypath[ 1 ..< keypath.endIndex ])
                return valueForKeypath(innerDict, newKeypath)
            }
        }
    }
    return nil
}


/**
    Attempts to descend through a nested tree of `Dictionary` objects to set the value of the key
    represented by `keypath`.  If a non-`Dictionary` type is encountered before reaching the end 
    of `keypath`, a `.Failure` is returned.  Note: this function returns the result of modifying
    the input `Dictionary` in this way; it does not modify `dict` in place.
 */
public func setValueForKeypath
    (var dict:[String: AnyObject], keypath:[String], value: AnyObject?) -> Result<[String: AnyObject], ErrorIO>
{
    precondition(keypath.count > 0, "keypath.count must be > 0")
    
    switch keypath.count
    {
        case 1:
            dict[keypath.first!] = value
            return success(dict)
        
        case let c where c > 1:
            let (firstKey, remainingKeys) = (first(keypath)!, dropFirst(keypath))
            if dict.indexForKey(firstKey) == nil {
                dict[firstKey] = [String: AnyObject]() as AnyObject
            }
            
            if var subDict = dict[firstKey] as? [String: AnyObject]
            {
                return setValueForKeypath(subDict, Array(remainingKeys), value)
                            .map { changedSubDict in
                                dict[firstKey] = changedSubDict
                                return dict
                            }
            }
            else { return failure("setValueForKeypath() -> found a value for dict[firstKey!] but it was not an NSDictionary") }
        
        default:
            return failure("Something weird happened in setValueForKeypath().  keypath.count = \(keypath.count)")
    }
}


public func mapIfIndex
    <S: SequenceType, D: ExtensibleCollectionType where S.Generator.Element == D.Generator.Element>
    (source: S, transform: S.Generator.Element -> S.Generator.Element, ifIndex: Int -> Bool) -> D
{
        var result = D()
        for (index, value) in enumerate(source) {
            if ifIndex(index) == true {
                result.append(transform(value))
            }
            else {
                result.append(value)
            }
        }
        return result
}


public func mapEveryNth
    <S: SequenceType, C: ExtensibleCollectionType where S.Generator.Element == C.Generator.Element>
    (source: S, n: Int, transform: S.Generator.Element -> S.Generator.Element) -> C
{
    // enumerate starts from zero, so for this to work with the nth element,
    // and not the 0th, n+1th etc, we need to add 1 to the ifIndex check:
    let isNth = { ($0 + 1) % n == 0 }

    return mapIfIndex(source, transform, isNth)
}






