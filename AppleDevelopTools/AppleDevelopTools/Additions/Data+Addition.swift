//
//  Data+Addition.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation
import CommonCrypto

public extension Data {

    var md5Hash:String {
        let data = (self as NSData).bytes
        let strLen = CUnsignedInt(self.count)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))

        CC_MD5(data, strLen, result)

        let result0 = result[0]
        let result1 = result[1]
        let result2 = result[2]
        let result3 = result[3]
        let result4 = result[4]
        let result5 = result[5]
        let result6 = result[6]
        let result7 = result[7]
        let result8 = result[8]
        let result9 = result[9]
        let result10 = result[10]
        let result11 = result[11]
        let result12 = result[12]
        let result13 = result[13]
        let result14 = result[14]
        let result15 = result[15]

        return String(format:"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result0, result1, result2, result3, result4, result5, result6, result7,
                      result8, result9, result10, result11, result12, result13, result14, result15)
    }

    var sha1Hash:String {
        let data = (self as NSData).bytes
        let strLen = CUnsignedInt(self.count)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))

        CC_SHA1(data, strLen, result)

        let result0 = result[0]
        let result1 = result[1]
        let result2 = result[2]
        let result3 = result[3]
        let result4 = result[4]
        let result5 = result[5]
        let result6 = result[6]
        let result7 = result[7]
        let result8 = result[8]
        let result9 = result[9]
        let result10 = result[10]
        let result11 = result[11]
        let result12 = result[12]
        let result13 = result[13]
        let result14 = result[14]
        let result15 = result[15]
        let result16 = result[16]
        let result17 = result[17]
        let result18 = result[18]
        let result19 = result[19]

        return String(format:"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result0, result1, result2, result3, result4, result5, result6, result7,
                      result8, result9, result10, result11, result12, result13, result14, result15,
                      result16, result17, result18, result19)
    }

    var base64EncodedString:String {
        return self.base64EncodedString(options: .lineLength64Characters)
    }

    static func dataWithBase64EncodedString(_ string:String) -> Data? {
        return Data(base64Encoded: string, options: .ignoreUnknownCharacters)
    }

    func isEmpty() -> Bool {
        return self.count <= 0
    }


}
