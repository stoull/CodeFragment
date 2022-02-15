//
//  MGDAUPenetratePackage.swift
//  ModBus
//
//  Created by Hut on 2022/2/11.
//

import Foundation

/// 命令码0x17 传给采集器的 对应的透传modbus数据包
class MGDAUPenetratePackage: MGModbusPackage {
    var dauSerial: String = ""
    var penetrateDataLenth: UInt16 = 0
    var penetrateData: Data?
    
    var penetrateModPackage: MGPenetrateModPackage?
    
    convenience init(dauSerial: String, penetratePackage pPackage: MGPenetrateModPackage){
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
        
        // 设置透传区数据的长度
        let pData = pPackage.asData()
        let length = pData.count
        
        dataArray.append(contentsOf: [UInt8(0), UInt8(length & 0xFF)])
        
        // 设置透传区数据
        dataArray.append(contentsOf: pData)
        let data = Data(dataArray)
    
        self.init(validData: data)
        
        self.penetrateDataLenth = UInt16(length)
        
        self.penetrateModPackage = pPackage
    }
    
    /**
     根据采集器返回的数据，生成包对象
     - Parameter para1: responseData 采集器响映的查询数据
     */
    init(responseData: Data) throws{
        try super.init(modbusPackage: responseData)
        
//        guard self.command == .DAU_read else {
//            throw MGModBusError(type: .commandTypeError)
//        }
        
        guard let validData = self.validData else {
            throw MGModBusError(type: .dataError)
        }
        
        let validDataArray = Array(validData)
        let length = validDataArray.count

        guard length > 9 else {
            print("数据长度有误，无序列号信息！")
            return
        }
        let serialData = validDataArray[0...9]
        if let serialStr = Data(serialData).stringUTF8 {
            self.dauSerial = serialStr
        }
        guard length > 10 else {print("MGDAUPenetratePackage 数据长度有误2，无透传数据长度信息！");return}
        penetrateDataLenth = Data(validDataArray[10...11]).uint16
        guard length > 11 else {print("MGDAUPenetratePackage 数据长度有误3，无透传数据！");return}
        penetrateData = Data(validDataArray[12...validDataArray.count-1])
        
        if let rData = penetrateData,
           let rPackage = try? MGPenetrateModPackage(responseData: rData) {
            self.penetrateModPackage = rPackage
        }
    }
    
    /// 直接使用数据区Data发送命令
    init(validData: Data, transactId: UInt16=0x00) {
        super.init(command: .DAU_via, validData: validData, transactId: transactId)
    }
}
