//
//  HttpMemoryCache.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpMemoryCache : HttpBaseCache {

    var localCache: HttpBaseCache?
    var memoryCache: NSCache<AnyObject, AnyObject>

    open override var cacheSize: Int {
        var totalCacheSize: Int
        if localCache != nil {
            totalCacheSize = localCache!.cacheSize
        } else {
            totalCacheSize = 0
        }
        return totalCacheSize
    }

    public override init() {
        self.memoryCache = NSCache()
        self.memoryCache.totalCostLimit = 10 * 1024 * 1024
    }

    //MARK:- Public Method
    open func changeLocalCache(_ cache: HttpDBCache) {
        self.localCache = cache
    }

    override open func clearCache() -> Void {
        self.memoryCache.removeAllObjects()
        self.localCache?.clearCache()
    }

    override open func removeObjectForKey(aKey: String) {
        self.memoryCache.removeObject(forKey: aKey as AnyObject)
        self.localCache?.removeObjectForKey(aKey: aKey)
    }

    override subscript(aKey:String) -> Data? {
        get {
            let object = self.memoryCache.object(forKey: aKey as AnyObject)
            return object as? Data
        }
        set {
            if newValue == nil {
                print("试图存入一个空的内容到内存缓存中，操作被忽略")
                return
            }
            self.memoryCache.setObject(newValue! as AnyObject, forKey: aKey as AnyObject, cost: newValue!.count)
        }
    }
}
