//
//  MGEncrypt.swift
//  GroHome
//
//  Created by Hut on 2021/11/16.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

struct MGEncrypt {
    static func MD5Hex(string: String) -> String {
        /*
         使用swift生成md5出现如下情况：
         使用MGEncrypt.swift文件中的MD5Hex(string: String) -> String方法对字符串'123456',得到的md5为：e10adc3949ba59abbe56e057f20f883e
         使用老版本中文件Old_Objective_C_MD5中的的MD5:(NSString *)str方法对字符串'123456',得到的md5为：e1cadc3949ba59abbe56e057f2cf883e
         另安卓的也是生成的字符串'123456'的md5为：e1cadc3949ba59abbe56e057f2cf883e
         不知道啥原因，为保诗一致性，使用老版本的算法。如谁知道的原因请一定告诉我非常感谢：changchunstep@gmail.com
         */

        return Old_Objective_C_MD5.md5(string)
        
//        return MD5(string: string).map { String(format: "%02hhx", $0) }.joined()

    }

    static func MD5Base64(string: String) -> String {
        return MD5(string: string).base64EncodedString()
    }

    static func MD5(string: String) -> Data {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData
    }

    static func isMD5HexString(string: String) -> Bool{
        let pattern = "^[a-f0-9]{32}$"
        if let regex = try? NSRegularExpression.init(pattern: pattern, options: .caseInsensitive),
           regex.numberOfMatches(in: string, options: .anchored, range: NSMakeRange(0, string.count)) == 1{
            return true
        }else {
            return false
        }
    }
}

