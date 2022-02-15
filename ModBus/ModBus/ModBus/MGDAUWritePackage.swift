//
//  MGDAUWritePackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

/// 命令码0x18 对应的modbus数据包
class MGDAUWritePackage: MGModbusPackage {
    var dauSerial: String = ""
    /// 参数编号个数
    var parasCount: Int = 1
    /// 状态码
    var code: MGModBusStatusType = .unknow
    /// 获取到有效数据
    var params: [MGDAUParameter: Data] = [:]
    
    convenience init(dauSerial: String, parameters: [MGDAUParameter: Data]){
        // 采集器序列号
        let serial = dauSerial
        var dataArray: [UInt8] = []
        if let serialData = serial.data(using: .utf8) {
            /// 补齐10位
            var paddingData = serialData
            if serialData.count < 10 {
                for _ in serialData.count...9{
                    paddingData.insert(0, at: 0)
                }
                print("DAUWritePackage 参数 采集器序列号 不足 10位")
            } else if serialData.count > 10 {
                paddingData = serialData[0...9]
                print("DAUWritePackage 参数 采集器序列号 多于 10位")
            }
            dataArray.append(contentsOf: Array(paddingData))
        }
        
        // 参数编号个数
        let count = parameters.count
        dataArray.append(contentsOf: [UInt8(count >> 8), UInt8(count & 0xFF)])
        
        // 设置数据的长度 (默认值，非准确值)
        var length = 0
        dataArray.append(contentsOf: [UInt8(0), UInt8(length & 0xFF)])
        
        // 设置数据
        for para in parameters {
            let number = para.key.number
            let value = para.value
            let dataLen = value.count
            dataArray.append(contentsOf: [UInt8(number >> 8), UInt8(number & 0xFF)])
            dataArray.append(contentsOf: [UInt8(dataLen >> 8), UInt8(dataLen & 0xFF)])
            dataArray.append(contentsOf: value)
            length = length + dataLen + 4
        }
        let data = Data(dataArray)
        
        // 设置数据的长度 (准确值)
        dataArray[12] = UInt8(length >> 8)
        dataArray[13] = UInt8(length & 0xFF)
        self.init(validData: data)
        
        self.dauSerial = dauSerial
        self.params = parameters
    }
    
    /**
     根据采集器返回的数据，生成包对象
     - Parameter para1: responseData 采集器响映的查询数据
     */
    init(responseData: Data) throws{
        print("0x18 Init with data: \(responseData.hexEncodedString().uppercased())")
        try super.init(modbusPackage: responseData)
        
//        guard self.command == .DAU_read else {
//            throw MGModBusError(type: .commandTypeError)
//        }
        
        guard let validData = self.validData else {
            throw MGModBusError(type: .dataError)
        }
        
        let validDataArray = Array(validData)
        let length = validDataArray.count

        guard length > k_MGDAU_serialNumber_lenthg-1 else {
            print("数据长度有误，无序列号信息！ValidData: \(validData.hexEncodedString().uppercased())")
            return
        }
        let serialData = validDataArray[0...k_MGDAU_serialNumber_lenthg-1]
        if let serialStr = Data(serialData).stringUTF8 {
            self.dauSerial = serialStr
        }
        guard length > k_MGDAU_serialNumber_lenthg else {print("0x18数据长度有误2，无参数编号个数信息！ValidData: \(validData.hexEncodedString().uppercased())");return}
        parasCount = Int(Data(validDataArray[10...11]).uint16)
        guard length > k_MGDAU_serialNumber_lenthg+1 else {print("0x18数据长度有误3，无状态码信息！ValidData: \(validData.hexEncodedString()).uppercased()");return}
        code = MGModBusStatusType(rawValue: validDataArray[k_MGDAU_serialNumber_lenthg+2]) ?? .unknow
    }
    
    /// 直接使用数据区Data发送命令
    init(validData: Data, transactId: UInt16=0x00) {
        super.init(command: .DAU_write, validData: validData, transactId: transactId)
    }
}
