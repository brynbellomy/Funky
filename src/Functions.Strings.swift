//
//  Functions.Strings.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public func stringify <T> (something:T) -> String {
    return "\(something)"
}


public func lines (str:String) -> [String] {
    return split(str) { $0 == "\n" }
}


public func dumpString<T>(value:T) -> String {
    var msg = ""
    dump(value, &msg)
    return msg
}


public func pad(string:String, length:Int, padding:String = " ") -> String {
    return string.stringByPaddingToLength(length, withString:padding, startingAtIndex:0)
}


public func padr(length:Int, padding:String = " ") (string:String) -> String {
    return pad(string, length, padding:padding)
}


public func padToSameLength <S: SequenceType where S.Generator.Element == String> (strings:S) -> [S.Generator.Element]
{
    let maxLength = strings |> mapr(countElements)
                            |> maxElement

    return strings |> mapr(padr(maxLength))
}


public func padKeysToSameLength <V> (dict: [String: V]) -> [String: V]
{
    let maxLength = dict |> mapr(takeLeft >>> countElements)
                         |> maxElement

    return dict |> mapKeys(padr(maxLength, padding:" "))
}


public func substringFromIndex (index:Int) (string:String) -> String
{
    let newStart = advance(string.startIndex, index)
    return string[newStart ..< string.endIndex]
}



public func substringToIndex (index:Int) (string:String) -> String
{
    let newEnd = advance(string.startIndex, index)
    return string[string.startIndex ..< newEnd]
}


public func describe <T> (array:[T]) -> String
{
    return describe(array) { stringify($0) }
}


public func describe <T> (array:[T], formatElement:(T) -> String) -> String
{
    return array |> mapr(formatElement >>> indent)
                 |> joinc(",\n")
                 |> { "[\n\($0)\n]" }
}


public func describe <K, V> (dict:[K: V]) -> String
{
    func renderKeyValue(key:String, value:V) -> String { return "\(key)  \(value)," }

    return dict |> mapKeys { "\($0):" }
                |> padKeysToSameLength
                |> mapr(renderKeyValue >>> indent)
                |> joinc("\n")
                |> { "{\n\($0)\n}" }
}


public func describe <K, V> (dict:[K: V], formatClosure:(K, V) -> String) -> String
{
    return dict |> mapr(formatClosure)
                |> mapr(indent)
                |> joinc(",\n")
                |> { "\n\($0)\n" }
}


public func indent(string:String) -> String
{
    let spaces = "    "
    return string |> splitr { $0 == "\n" } //{ str in split(str) { $0 == "\n" } }
                  |> mapr { "\(spaces)\($0)" }
                  |> joinc("\n")
}


public func basename(path:String) -> String {
    return path.lastPathComponent
}


public func extname(path:String) -> String {
    return path.pathExtension
}


public func dirname(path:String) -> String {
    return path.stringByDeletingLastPathComponent
}




/**
    Generates an NS- or UIColor from a hex color string.

    :param: hex The hex color string from which to create the color object.  '#' sign is optional.
 */
public func rgbaFromHexCode(hex:String) -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)?
{
    var colorString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

    if colorString.hasPrefix("#") {
        colorString = colorString |> substringFromIndex(1)
    }

    let stringLength = countElements(colorString)
    if stringLength != 6 && stringLength != 8 {
        return nil
    }

    var rString = colorString |> substringToIndex(2)
    var gString = colorString |> substringFromIndex(2) |> substringToIndex(2)
    var bString = colorString |> substringFromIndex(4) |> substringToIndex(2)
    var aString: String?

    // if we have a fourth hex value (alpha)
    if stringLength == 8 {
        aString = colorString |> substringFromIndex(6) |> substringToIndex(2)
    }

    var r: CUnsignedInt = 0
    var g: CUnsignedInt = 0
    var b: CUnsignedInt = 0
    var a: CUnsignedInt = 255

    NSScanner(string:rString).scanHexInt(&r)
    NSScanner(string:gString).scanHexInt(&g)
    NSScanner(string:bString).scanHexInt(&b)
    if let aString = aString? {
        NSScanner(string:aString).scanHexInt(&a)
    }

    let red     = CGFloat(r) / 255.0
    let green   = CGFloat(g) / 255.0
    let blue    = CGFloat(b) / 255.0
    let alpha   = CGFloat(a) / 255.0

    return (red:red, green:green, blue:blue, alpha:alpha)
}


public func rgbaFromRGBAString(string:String) -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)?
{
    var error: NSError?
    let regex = NSRegularExpression(pattern: "[^0-9,\\.]", options:NSRegularExpressionOptions.allZeros, error: &error)

    if let error = error {
        NSLog("Error: \(error.localizedDescription)")
        return nil
    }

    if regex == nil {
        NSLog("NSRegularExpression.init returned nil but no error.")
        return nil
    }

    let range = NSMakeRange(0, countElements(string))
    let sanitized: String! = regex!.stringByReplacingMatchesInString(string, options:NSMatchingOptions.allZeros, range:range, withTemplate:String(""))

    let parts: [String] = split(sanitized) { $0 == "," }
    if parts.count != 4 {
        return nil
    }

    if let (red, green, blue, alpha) = all(parts[0].toCGFloat(), parts[1].toCGFloat(), parts[2].toCGFloat(), parts[3].toCGFloat()) {
        return (red:red, green:green, blue:blue, alpha:alpha)
    }

    return nil
}


private extension String
{
    func toCGFloat() -> CGFloat? {
        return CGFloat((self as NSString).floatValue)
    }
}
