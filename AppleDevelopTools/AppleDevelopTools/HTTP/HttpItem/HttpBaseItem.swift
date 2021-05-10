//
//  HttpBaseItem.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

public enum HttpCacheType : Int {
    case cacheAndServer = 0
    case cacheOrServer
    case cacheOnly
    case serverOnly
    case cacheServerSameResultOneCall
}

protocol HttpRequestLifeCycle {
    func httpStart(item: HttpBaseItem) -> Void
    func httpProgress(item: HttpBaseItem, percent: Float) -> Void
    func httpComplete(item: HttpBaseItem) -> Void
    func httpFailure(item: HttpBaseItem, statusCode: Int, errorMessage: String) -> Void
}

open class HttpBaseItem: HttpRequestLifeCycle {
    static fileprivate let emptyData = Data()

    open var baseUrlString: String = ""
    open var relativeUrlString: String = ""
    open var absoluteUrlString: String {
        return baseUrlString + relativeUrlString
    }
    open var method: String = "GET"

    open var requestHeaderDict = [String: String]()
    open var requestContent: Data = emptyData
    open var requestContentEncoding: String.Encoding = String.Encoding.utf8

    open var responseHeaderDict = [String: String]()
    open var responseContent: Data = emptyData
    open var httpStatusCode: Int = 0
    open var code: Int = -1000

    open var cacheType: HttpCacheType = .cacheServerSameResultOneCall
    open var fromeCache: Bool = false
    open var canCache: Bool {
        return false
    }
    var ignoreCallback = false
    var cacheKey: String?

    open var accessTokenExpireTimes: Int = 0
    open var timeoutInterval: Double = 0

    open var successCallback = {(item: HttpBaseItem) in }
    open var httpFailureCallback = {(item:HttpBaseItem, statusCode: Int, errorMessage: String) in }
    open var codeFailureCallback = {(item: HttpBaseItem) in }

    open var isEnd: Bool = false

    open weak var batch: HttpBatch?

    open func serializeHTTPRequest() {

    }

    open func deserializeHTTPResponse(_ responseData: Data) {

    }

    func httpStart(item:HttpBaseItem) {

    }

    func httpProgress(item:HttpBaseItem, percent:Float) {

    }

    func httpComplete(item:HttpBaseItem) {

        if item.ignoreCallback == false {
            item.code < 0 ? self.codeFailureCallback(self) : self.successCallback(self)
        }

        if item.batch != nil {
            item.batch!.httpComplete(item: item)
        }
    }

    func httpFailure(item:HttpBaseItem, statusCode: Int, errorMessage: String) {

        self.httpFailureCallback(self, statusCode, errorMessage)

        if item.batch != nil {
            item.batch!.httpFailure(item: item, statusCode: statusCode, errorMessage: errorMessage)
        }
    }
}
