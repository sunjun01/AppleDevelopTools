//
//  Http201Runner.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class Http201Runner: HttpCodeBaseRunner {
    override open var httpCode: Int {
        return 201
    }

    override init() {
        super.init()
        self.message = ""
    }

    override open func processingMode(_ baseItem: HttpBaseItem, data: Data?) {
        let key = self.cacheKey(baseItem)
        let oldData = HttpCacheManager.shareInstance.objectForKey(key)

        if (oldData != nil && (oldData! == data!) && baseItem.cacheType == .cacheServerSameResultOneCall) {
            baseItem.ignoreCallback = true
        }
        HttpCacheManager.shareInstance.addObject(data!, forKey: key)
        baseItem.deserializeHTTPResponse(data!)
        DispatchQueue.main.async(execute: {
            baseItem.httpComplete(item: baseItem)
        })

    }

    fileprivate func cacheKey(_ item: HttpBaseItem) -> String {
        var key: String = ""
        switch item.method {
        case "GET":
            key = item.absoluteUrlString.md5Hash
        case "POST":
            let urlMD5 = item.absoluteUrlString.md5Hash
            let requestContentMD5 = item.requestContent.md5Hash
            key = urlMD5 + requestContentMD5
        default:
            key = item.absoluteUrlString.md5Hash
        }
        return key
    }
}
