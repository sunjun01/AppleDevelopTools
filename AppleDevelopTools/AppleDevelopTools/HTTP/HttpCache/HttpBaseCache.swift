//
//  HttpBaseCache.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpBaseCache : NSObject {

    var cacheSize: Int {
        return 0
    }

    //MARK:- Public Method
    func clearCache() {

    }

    func removeObjectForKey(aKey: String) {

    }

    subscript(aKey:String) -> Data? {
        get {
            return nil
        }
        set {

        }
    }
}
