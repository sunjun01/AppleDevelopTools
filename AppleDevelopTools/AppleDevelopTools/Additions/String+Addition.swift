//
//  String+Addition.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation
import CommonCrypto

public extension String {

    var md5Hash:String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str, strLen, result)

        let hash = NSMutableString()

        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }

        return String(format: hash as String)
    }

    var sha1Hash:String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_SHA1(str, strLen, result)

        let hash = NSMutableString()

        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }

        return String(format: hash as String)
    }

    func isEmpty() -> Bool {
        return self.count <= 0
    }

    func urlEncodedString() -> String {
        let customAllowedSet =  CharacterSet(charactersIn:" =\"#%/<>?@\\^`{|}").inverted
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }

}
