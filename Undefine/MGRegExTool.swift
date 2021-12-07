//
//  MGRegExTool.swift
//  GroHome
//
//  Created by Hut on 2021/11/15.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import Foundation

struct MGRegExTool {
    enum GHRegExCheckType {
        case username
        case password
        case phonenumber
        case email
        case ipv4
        case ipv6
        case netmask
        case httpUrl
        case id_crad
        case passport
        case verificationCode
        
        var rexString: String {
            var regExStr = ""
            switch self {
            case .username:
                regExStr = "^.{3,30}$"
            case .password:
                // 且包含特殊字符及大小写字母 （特殊字符为~@#_^*%/.+:;=$&! 密码大于8位）
//                regExStr = "^.*(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[~@#_^*%/.+:;=$&!])[0-9A-Za-z~@#_^*%/.+:;=$&!]{8,}$"
                
                //  密码大于8位，且包含特殊字符及大小写字母 （特殊字符为数字字母以外的字符）
//                regExStr = "^(?![A-Za-z0-9]+$)(?![a-z0-9\\W]+$)(?![A-Za-z\\W]+$)(?![A-Z0-9\\W]+$)[a-zA-Z0-9\\W]{8,}$"
                
                //  密码大于8位，且为数字、字母、特殊符号的任意的两种组合
                regExStr = "^(?![a-zA-z]+$)(?!\\d+$)(?![!@#$%^&*]+$)[a-zA-Z\\d!@#$%^&*]{6,20}$"
                
            case .phonenumber:
                /**
                 18005551234
                 1 800 555 1234
                 +1 800 555-1234
                 +86 800 555 1234
                 1-800-555-1234
                 1 (800) 555-1234
                 (800)555-1234
                 (800) 555-1234
                 (800)5551234
                 800-555-1234
                 800.555.1234
                 800 555 1234x5678
                 8005551234 x5678
                 1    800    555-1234
                 1----800----555-1234
                 */
                regExStr = "^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$"
                
                /**
                 123-456-7890
                 (123) 456-7890
                 123 456 7890
                 123.456.7890
                 +91 (123) 456-7890
                 */
//                regExStr = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$"
                
            case .email:
                regExStr = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            case .ipv4:
                regExStr = "^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)(\\.(?!$)|$)){4}$"
            case .ipv6:
                /// include 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
                regExStr = "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
            case .netmask:
                regExStr = "^((128|192)|2(24|4[08]|5[245]))(\\.(0|(128|192)|2((24)|(4[08])|(5[245])))){3}$"
            case .httpUrl:
                regExStr = "^((http|https|smtp)://)?(www.)?([a-zA-Z0-9#-\\\\./?=&]+)\\.([a-zA-Z0-9#-\\\\./?=&]+)"
            case .id_crad:
                // 区位码校验、出生年月日校验（前正则限制起始年份为1900）、校验码判断
                regExStr = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"
            case .passport:
                // 规则： 14/15开头 + 7位数字, G + 8位数字, P + 7位数字, S/D + 7或8位数字,等
                regExStr = "^([a-zA-z]|[0-9]){5,17}$"
            case .verificationCode:
                regExStr = "^\\d{6}$"
            }
            return regExStr
        }
    }

    func checkIsValid(checkType: GHRegExCheckType, targetString: String) -> Bool {
        let rexgexExpression = checkType.rexString
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexgexExpression)
        if !predicate.evaluate(with: targetString) {
            return false
        } else {
            return true
        }
    }
    
    func checkIsValid(regExString: String, targetString: String) -> Bool {
        let rexgexExpression = regExString
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexgexExpression)
        if !predicate.evaluate(with: targetString) {
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: - 使用正则表达式进行匹配
    
    ///  使用正则表达式进行匹配, 结果的数据格式为： ["matched1", "matched2", "matched3",...]
    static func matches(string: String, for regex: String) -> [String] {
        do {
            let text = string
            let regex = try NSRegularExpression(pattern: regex)
            let result = regex.matches(in: text,
                                       range: NSRange(text.startIndex..., in: text))
            
            return result.map {String(text[Range($0.range, in: text)!]) }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 使用正则表达式进行匹配(可分组), 结果的数据格式为： [["All", "Group1", "Group2",...]...]
    static func matcheGroups(string: String, for regexPattern: String) -> [[String]] {
        do {
            let text = string
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
