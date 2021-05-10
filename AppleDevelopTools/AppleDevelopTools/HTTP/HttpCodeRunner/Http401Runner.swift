//
//  Http401Runner.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class Http401Runner: HttpCodeBaseRunner {
    override open var httpCode: Int {
        return 401
    }

    let repeatCount = 3

    override init() {
        super.init()
        self.message = "http error 401"
    }

    fileprivate var refreshTokenBlock = {(item: HttpBaseItem) in
        DispatchQueue.main.async(execute: {
            item.httpFailure(item: item, statusCode: item.httpStatusCode, errorMessage: "")
        })
    }

    func setRefreshTokenBlock(_ block: @escaping (HttpBaseItem) -> (Void)) {
        self.refreshTokenBlock = block
    }

    override open func processingMode(_ baseItem: HttpBaseItem, data: Data?) {
        if baseItem.accessTokenExpireTimes > repeatCount {
            DispatchQueue.main.async(execute: {
                baseItem.httpFailure(item: baseItem, statusCode: baseItem.httpStatusCode, errorMessage: self.message)
            })
            return
        }
        baseItem.accessTokenExpireTimes += 1
        DispatchQueue.main.async(execute: {
            self.refreshTokenBlock(baseItem)
        })
    }
}
