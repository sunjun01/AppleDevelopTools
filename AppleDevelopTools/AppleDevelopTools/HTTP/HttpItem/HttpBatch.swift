//
//  HttpBatch.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpBatch : HttpRequestLifeCycle {

    open var itemList = [HttpBaseItem]()
    open var successCallback = {(batch: HttpBatch) in }
    open var httpFailureCallback = {(batch: HttpBatch, statusCode: Int, errorMessage: String) in }

    var httpStatusCode: Int = 0
    var isFailure: Bool = false
    var errorMessage: String = ""

    //MARK:- Public Method
    open func addItem(item: HttpBaseItem, successCallback success: @escaping ((HttpBaseItem) -> Void), codeFailureCallback codeFailure: @escaping ((HttpBaseItem) -> Void)) {
        item.batch = self
        item.successCallback = success
        item.codeFailureCallback = codeFailure
        itemList.append(item)
    }

    //MARK:- Private Method
    fileprivate func checkEnd() -> Bool {
        for item: HttpBaseItem in itemList {
            if item.isEnd == false {
                return false
            }
        }
        return true
    }

    fileprivate func batchComplete() {
        if self.checkEnd() == false {
            return
        }

        if self.isFailure {
            self.httpFailureCallback(self, self.httpStatusCode, self.errorMessage)
        } else {
            self.successCallback(self)
        }
    }

    //MARK:- HttpRequestLifeCycle
    func httpStart(item: HttpBaseItem) {

    }

    func httpProgress(item: HttpBaseItem, percent: Float) {

    }

    func httpComplete(item:HttpBaseItem) {
        self.batchComplete()
    }

    func httpFailure(item:HttpBaseItem, statusCode: Int, errorMessage: String) {
        self.isFailure = true
        self.httpStatusCode = statusCode
        self.batchComplete()
    }
}
