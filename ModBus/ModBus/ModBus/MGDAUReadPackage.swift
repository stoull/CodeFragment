//
//  MGDAUReadPackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

class MGDAUReadPackage: MGModbusPackage {
    var dauSerial: String = ""
    /// 参数编号个数
    var parasCount: Int = 1
    /// 状态码
    var code: Int = 0
    /// 获取到有效数据
    var data: [String] = []
    
    convenience init(parameters: [MGDAUParameter]){
        self.init()
        
        // 采集器序列号
        let serial = ""
        var dataArray: [UInt8] = []
        if let serialData = serial.data(using: .utf8) {
            dataArray.append(contentsOf: Array(serialData))
        }
        
        // 参数编号个数
        let count = parameters.count
        dataArray.append(contentsOf: [UInt8(count >> 8), UInt8(count & 0xFF)])
        
        // 设置数据
        for para in parameters {
            let number = para.number
            dataArray.append(contentsOf: [UInt8(number >> 8), UInt8(number & 0xFF)])
        }
        
        let data = Data(dataArray)
        
        self.validData = data
        self.length = UInt16(data.count)
    }
    
    /**
     根据采集器返回的数据，生成包对象
     - Parameter para1: responseData 采集器响映的查询数据
     */
    convenience init(responseData: Data) {
        self.init()
        
        就到这里吧
        let dataArray = Array(responseData)
        guard dataArray.count > 8 else {return}
        self.transactId = UInt16(dataArray[0]) + UInt16(dataArray[1])
        self.protocolId = UInt16(dataArray[2]) + UInt16(dataArray[3])
        let lenght = UInt16(dataArray[4]) + UInt16(dataArray[5])
        self.length = lenght
        self.slaveAdress = dataArray[6]
        self.command = ModCommand(rawValue: dataArray[7]) ?? .unkonw
        self.validData = Data(dataArray[8...Int(length)])
        self.functionType = .read
        
        self.validData = responseData
        self.length = UInt16(responseData.count)
    }
    
    init() {
        super.init(functionType: .read)
    }
    
    
    func unpackReadingPackage(data: Data) {
        let dataArray = Array(data)
        guard dataArray.count > 8 else {return}
        self.transactId = UInt16(dataArray[0]) + UInt16(dataArray[1])
        self.protocolId = UInt16(dataArray[2]) + UInt16(dataArray[3])
        let lenght = UInt16(dataArray[4]) + UInt16(dataArray[5])
        self.length = lenght
        self.slaveAdress = dataArray[6]
        self.command = ModCommand(rawValue: dataArray[7]) ?? .unkonw
        self.validData = Data(dataArray[8...Int(length)])
        self.functionType = .read
    }
}
