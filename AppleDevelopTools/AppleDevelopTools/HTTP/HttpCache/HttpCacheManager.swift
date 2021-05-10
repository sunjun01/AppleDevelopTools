//
//  HttpCacheManager.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpCacheManager {
    lazy var cachePool = [HttpBaseCache]()

    open var cacheSize: Int {
        var totalSize = 0
        for cache in self.cachePool {
            totalSize += cache.cacheSize
        }
        return totalSize
    }

    //MARK:- Singleton
    public static let shareInstance = HttpCacheManager()

    //MARK:- Public Method
    open func addCache(_ cache: HttpBaseCache) {
        self.cachePool.append(cache)
    }

    open func clearCache() -> Void {
        for cache in self.cachePool {
            cache.clearCache()
        }
    }

    open func addObject(_ object: Data, forKey aKey: String) {
        for cache in self.cachePool {
            cache[aKey] = object
        }
    }

    open func removeObjectForKey(_ aKey: String) {
        for cache in self.cachePool {
            cache.removeObjectForKey(aKey: aKey)
        }
    }

    open func objectForKey(_ aKey: String) -> Data? {
        var data: Data? = nil;
        var indexNumber:Int = 0
        for cache in self.cachePool {
            data = cache[aKey]
            if data != nil {
                break
            }
            indexNumber += 1
        }

        if data == nil {
            return nil
        }

        self.fillCache(data!, aKey: aKey, index: indexNumber)

        return data
    }

    //MARK:- Private Method
    fileprivate func fillCache(_ data: Data, aKey: String, index: Int) {
        var indexNumber = index - 1
        while indexNumber > 0 {
            let pendingCache = self.cachePool[indexNumber]
            pendingCache[aKey] = data
            indexNumber -= 1
        }
    }
}
