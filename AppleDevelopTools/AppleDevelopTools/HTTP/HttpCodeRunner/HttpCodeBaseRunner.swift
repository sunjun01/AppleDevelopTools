//
//  HttpCodeBaseRunner.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation

open class HttpCodeBaseRunner {
    open var httpCode: Int {
        return 0
    }

    open var message = ""
    func run(_ baseItem: HttpBaseItem, data: Data?) {
        if baseItem.httpStatusCode != self.httpCode {
            return
        }
        processingMode(baseItem, data: data)
    }

    open func processingMode(_ baseItem: HttpBaseItem, data: Data?) {

    }
}
