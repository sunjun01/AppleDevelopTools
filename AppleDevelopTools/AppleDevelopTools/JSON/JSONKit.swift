//
//  File.swift
//  
//
//  Created by 孙俊 on 2021/5/7.
//

import Foundation

extension String {
    public func jsonObject() -> Any? {
        let jsonData = self.data(using: .utf8)
        if jsonData == nil {
            return nil
        }
        let obj = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
        return obj
    }
}

extension Data {
    public func jsonObject() -> Any? {
        let obj = try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves)
        return obj
    }
}

extension Dictionary {
    public func jsonString() -> String? {
        let isValidJSONObject = JSONSerialization.isValidJSONObject(self)
        if isValidJSONObject == false {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        if data == nil {
            return nil
        }
        return String(data: data!, encoding: .utf8)
    }

    public func jsonData() -> Data? {
        let isValidJSONObject = JSONSerialization.isValidJSONObject(self)
        if isValidJSONObject == false {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
}

extension Array {
    public func jsonString() -> String? {
        let isValidJSONObject = JSONSerialization.isValidJSONObject(self)
        if isValidJSONObject == false {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        if data == nil {
            return nil
        }
        return String(data: data!, encoding: .utf8)
    }

    public func jsonData() -> Data? {
        let isValidJSONObject = JSONSerialization.isValidJSONObject(self)
        if isValidJSONObject == false {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
}
