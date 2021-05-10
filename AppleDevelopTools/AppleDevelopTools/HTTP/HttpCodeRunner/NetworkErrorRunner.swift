//
//  NetworkErrorRunner.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class NetworkErrorRunner : HttpCodeBaseRunner {
    override open var httpCode: Int {
        return -10000
    }

    override init() {
        super.init()
        self.message = "Network error"
    }

    override open func processingMode(_ baseItem: HttpBaseItem, data: Data?) {
        DispatchQueue.main.async(execute: {
            baseItem.httpFailure(item: baseItem, statusCode: baseItem.httpStatusCode, errorMessage: self.message)
        })
    }
}
