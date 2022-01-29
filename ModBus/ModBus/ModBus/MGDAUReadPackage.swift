//
//  MGDAUReadPackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

/// 命令码0x19 对应的modbus数据包
class MGDAUReadPackage: MGModbusPackage {
    var dauSerial: String = ""
    /// 参数编号个数
    var parasCount: Int = 1
    /// 状态码
    var code: MGModBusStatusType = .unknow
    /// 获取到有效数据
    var params: [UInt16: Data] = [:]
    
    convenience init(parameters: [MGDAUParameter]){
        
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
        
        self.init(validData: data)
    }
    
    /**
     根据采集器返回的数据，生成包对象
     - Parameter para1: responseData 采集器响映的查询数据
     */
    init(responseData: Data) throws{
        try super.init(modbusPackage: responseData)
        
        guard self.command == .DAU_read else {
            throw MGModBusError(type: .commandTypeError)
        }
        
        
        guard let validData = self.validData else {
            throw MGModBusError(type: .dataError)
        }
        
        let validDataArray = Array(validData)
        let length = validDataArray.count

        guard length > 9 else {return}
        let serialData = validDataArray[0...9]
        if let serialStr = Data(serialData).stringUTF8 {
            self.dauSerial = serialStr
        }
        guard length > 11 else {return}
        parasCount = Int(Data(validDataArray[10...11]).uint16)
        guard length > 12 else {return}
        code = MGModBusStatusType(rawValue: validDataArray[12]) ?? .unknow
        
        就到这里吧
        
        var point = 13
        while point < length {
            let paraNum = Data(validDataArray[point...point+1]).uint16
            let paraLen = Data(validDataArray[point+2...point+3]).uint16
            point = point + 4
            let paraData = Data(validDataArray[point...point+Int(paraLen)])
            params[paraNum] = paraData
            point = point+Int(paraLen)
        }
        
    }
    
    init(validData: Data, transactId: UInt16=0x00) {
        super.init(command: .DAU_read, validData: validData, transactId: transactId)
    }
}
