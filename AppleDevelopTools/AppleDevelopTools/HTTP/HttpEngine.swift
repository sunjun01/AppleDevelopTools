//
//  HttpEngine.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpEngine {
    var runnerPool = [HttpCodeBaseRunner]()

    //MARK:- Singleton
    public static let shareInstance = HttpEngine()
    init() {
        self.addRunner(Http401Runner())
        self.addRunner(Http404Runner())
        self.addRunner(Http500Runner())
        self.addRunner(Http200Runner())
        self.addRunner(Http201Runner())
        self.addRunner(NetworkErrorRunner())
    }

    //MARK:- Public Method
    open func invokeItem(_ item: HttpBaseItem, successCallback: @escaping ((_ item:HttpBaseItem) -> Void), codeFailureCallback: @escaping ((_ item:HttpBaseItem) -> Void), httpFailureCallback: @escaping ((_ item:HttpBaseItem, _ code:Int, _ message:String) -> Void)) {

        item.successCallback = successCallback
        item.codeFailureCallback = codeFailureCallback
        item.httpFailureCallback = httpFailureCallback

        self.getDataWithItem(item)
    }

    open func invokeBatch(_ batch: HttpBatch, cacheType: HttpCacheType?, successCallback: @escaping ((_ batch:HttpBatch) -> Void), httpFailureCallback: @escaping ((_ batch:HttpBatch, _ code:Int, _ message:String) -> Void)) {
        batch.successCallback = successCallback
        batch.httpFailureCallback = httpFailureCallback

        if batch.itemList.count == 0 {
            return;
        }

        self.correctCacheType(batch.itemList, cacheType: cacheType)

        for item in batch.itemList {
            self.getDataWithItem(item, batch: batch)
        }
    }

    open func addRunner(_ runner: HttpCodeBaseRunner) {
        self.runnerPool.append(runner)
    }

    //外部程序可以使用此方法自定义401错误的处理逻辑，否则执行默认逻辑
    open func setRefreshTokenBlock(_ block: @escaping (_ item:HttpBaseItem) -> (Void)) {
        for runner in self.runnerPool {
            if runner.httpCode == 401 {
                let tokenRunner = runner as! Http401Runner
                tokenRunner.setRefreshTokenBlock(block)
            }
        }
    }

    //MARK:- Private Method
    fileprivate func correctCacheType(_ itemList: [HttpBaseItem], cacheType: HttpCacheType?) -> Void {
        var needCorrection = false
        var newCacheType = HttpCacheType.serverOnly

        if (cacheType != nil) {
            needCorrection = true
            newCacheType = cacheType!
        }
        else {
            for item in itemList {
                if item.cacheType == .serverOnly {
                    needCorrection = true
                    newCacheType = .serverOnly
                    break
                }
            }
        }

        if (needCorrection) {
            for item in itemList  {
                item.cacheType = newCacheType
            }
        }
    }

    fileprivate func getDataWithItem(_ item: HttpBaseItem, batch: HttpBatch? = nil) -> Void {

        item.serializeHTTPRequest()
        let url = URL(string: item.absoluteUrlString)
        if url == nil {
            //跳转错误处理
            item.fromeCache = false
            item.isEnd = true
            item.httpFailure(item: item, statusCode: item.httpStatusCode, errorMessage: "URL格式不正确")
            return
        }

        item.httpStart(item: item)

        let cacheKey = self.cacheKey(item)

        var responseData: Data? = nil;
        if self.canRequestCache(item) {
            responseData = HttpCacheManager.shareInstance.objectForKey(cacheKey)

            item.fromeCache = true
            item.isEnd = self.isLastCallback(item, responseData: responseData)
            if responseData == nil {
                //取缓存失败回调
                if item.cacheType == .cacheOnly {
                    item.httpFailure(item: item, statusCode: item.httpStatusCode, errorMessage: "未取到Cache")
                }
            } else {
                //取缓存成功回调
                item.deserializeHTTPResponse(responseData!)
                item.httpComplete(item: item)
            }
        }

        item.fromeCache = false
        item.isEnd = true

        if self.canRequestServer(item, responseData: responseData) {

            let urlRequest = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)

            urlRequest.httpMethod = item.method
            urlRequest.allHTTPHeaderFields = item.requestHeaderDict
            urlRequest.httpBody = item.requestContent

            let urlSession = URLSession.shared
            let dataTask = urlSession.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    print("\(error!.localizedDescription)")
                }
                let httpResponse = response as? HTTPURLResponse
                if httpResponse == nil {
                    item.httpStatusCode = -10000
                } else {
                    item.httpStatusCode = httpResponse!.statusCode
                }
                for runner in self.runnerPool {
                    runner.run(item, data: data)
                }
            })
            dataTask.resume()
        }
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

    fileprivate func canRequestCache(_ item: HttpBaseItem) -> Bool {
        switch item.cacheType {
        case .cacheAndServer:
            return true
        case .cacheOrServer:
            return true
        case .cacheOnly:
            return true
        case .serverOnly:
            return false
        case .cacheServerSameResultOneCall:
            return true
        }
    }

    fileprivate func isLastCallback(_ item: HttpBaseItem, responseData: Data?) -> Bool {
        switch item.cacheType {
        case .cacheAndServer:
            return false
        case .cacheOrServer:
            if responseData != nil {
                return true
            } else {
                return false
            }
        case .cacheOnly:
            return true
        case .serverOnly:
            return false
        case .cacheServerSameResultOneCall:
            return false
        }
    }

    fileprivate func canRequestServer(_ item: HttpBaseItem, responseData: Data?) -> Bool {
        switch item.cacheType {
        case .cacheAndServer:
            return true
        case .cacheOrServer:
            if responseData == nil {
                return true
            } else {
                return false
            }
        case .cacheOnly:
            return false
        case .serverOnly:
            return true
        case .cacheServerSameResultOneCall:
            return true
        }
    }
}
