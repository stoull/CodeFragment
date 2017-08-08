//
//  historyDocument.swift
//  Securing_iOS_Data
//
//  Created by linkapp on 08/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import Foundation
class historyDocument: NSObject, NSSecureCoding {

    var serialNumber: Int64
    var fileName: String?
    
    
    // 重写自定义类中的 supportsSecureCoding 进行安全序列化
    static var supportsSecureCoding : Bool
    {
        get
        {
            return true
        }
    }
    
    override init() {
        serialNumber = 0
        fileName = "fileName"
        super.init()
    }
    
    
    // 解码
    required init?(coder aDecoder: NSCoder)
    {
        serialNumber = aDecoder.decodeInt64(forKey: "serialNumber")
        fileName = aDecoder.decodeObject(forKey: "fileName") as? String
    }
    
    // 编码
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(fileName, forKey:"fileName")
    }
    
    override var description: String{
        get {
            return "Document: \(String(describing: fileName)), serialNumber: \(serialNumber)"
        }
    }
}
