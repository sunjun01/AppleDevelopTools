//
//  Http500Runner.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class Http500Runner: HttpCodeBaseRunner {
    override open var httpCode: Int {
        return 500
    }

    override init() {
        super.init()
        self.message = "Http error 500"
    }

    override open func processingMode(_ baseItem: HttpBaseItem, data: Data?) {
        DispatchQueue.main.async(execute: {
            baseItem.httpFailure(item: baseItem, statusCode: baseItem.httpStatusCode, errorMessage: self.message)
        })
    }
}
