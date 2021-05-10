//
//  Dictionary+Addition.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

public extension Dictionary where Key == StringLiteralType, Value == Any {
    func isEmpty() -> Bool {
        return self.count <= 0
    }

    func stringForKey(Key:String) -> String? {
        return self[Key] as? String
    }

    func numberForKey(_ key:String) -> NSNumber? {
        return self[key] as? NSNumber
    }

    func dictionaryForKey(_ key:String) -> Dictionary? {
        return self[key] as? Dictionary
    }

    func arrayForKey(_ key:String) -> Array<Any>? {
        return self[key] as? Array<Any>
    }

    func floatForKey(_ key:String) -> Float? {
        return self[key] as? Float
    }

    func doubleForKey(_ key:String) -> Double? {
        return self[key] as? Double
    }

    func int32ForKey(_ key:String) -> Int32? {
        return self[key] as? Int32
    }

    func intForKey(_ key:String) -> Int? {
        return self[key] as? Int
    }

    func uIntForKey(_ key:String) -> UInt? {
        return self[key] as? UInt
    }

    func longLongForKey(_ key:String) -> Int64? {
        return self[key] as? Int64
    }

    func BOOLForKey(_ key:String) -> Bool? {
        return self[key] as? Bool
    }
}
