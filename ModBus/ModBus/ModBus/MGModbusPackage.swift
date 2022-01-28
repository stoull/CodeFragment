//
//  MGModbusPackage.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/21.
//

import Foundation
import CryptoSwift
import BigInt

class MGModbusPackage {
    var modMode: ModbusMode = .tcp
    var functionType: MGModbusCommandType = .heartBeat
    var validData: Data?
    

    /// 事务处理标识 仅tcp mode下有
    var transactId: UInt16 = 0x00
    /// 协议标识符 00 00表示ModbusTCP协议 仅tcp mode下有
    var protocolId: UInt16 = 0x0005
    /// 数据长度
    var length: UInt16 = 0x00
    /// 单元标识符 可以理解为设备地址
    var slaveAdress: UInt8 = 0x01
    
    var command: Command = .unkonw
    
    convenience init(with characteristicData: Data) {
        self.init()
        let dataArray = Array(characteristicData)
        guard dataArray.count > 8 else {return}
        self.transactId = UInt16(dataArray[0]) + UInt16(dataArray[1])
        self.protocolId = UInt16(dataArray[2]) + UInt16(dataArray[3])
        let lenght = UInt16(dataArray[4]) + UInt16(dataArray[5])
        self.length = lenght
        self.slaveAdress = dataArray[6]
        self.command = Command(rawValue: dataArray[7]) ?? .unkonw
        self.validData = Data(dataArray[8...Int(length)])
        self.functionType = .inquiry
    }
    
    convenience init(functionType: MGModbusCommandType, data: Data) {
        self.init()
        self.functionType = functionType
        self.validData = data
        self.length = UInt16(data.count)
    }
    
    
    var asData: Data {
        let commandType: Command = functionType.modbusCommand
        
        if let validData = self.validData {
            let cmdData = createCommand(command: commandType, data: Array(validData))
//            print("as cmd data: \(cmdData.hexEncodedString())")
            return cmdData
        } else {
            let cmdData = createCommand(command: commandType, data: Array())
//            print("as cmd data: \(cmdData.hexEncodedString())")
            return cmdData
        }
    }
    
    /// 将有效数据转换为string
    var stringData: String {
        if let vData = self.validData {
            return String(data: vData, encoding: .utf8) ?? ""
        } else {
            return ""
        }
    }
    
    /// 创建modbus命令
    private func createCommand(command: Command, data: [UInt8]) -> Data {
        var package = [UInt8]()
        
        if self.modMode == .tcp {
            // mbap in tcp mode
            let lenght = data.count + 2 // 数据加功能码及设备地址两字节
            package.append(contentsOf: [UInt8(transactId >> 8), UInt8(transactId & 0xFF)])
            package.append(contentsOf: [UInt8(protocolId >> 8), UInt8(protocolId & 0xFF)])
            package.append(contentsOf: [UInt8(lenght >> 8), UInt8(lenght & 0xFF)])  // 从下一字节到最后一个字节的长度
        }
        transactId += 1
        package.append(slaveAdress)    // 地址位 Unit ID 一字节
        package.append(command.rawValue)   // Function Code 一字节
//        package.append(contentsOf: [UInt8(address >> 8), UInt8(address & 0xFF)])
        if data.count > 0 {
            package.append(contentsOf: data)
        }
//        let crcCode = data.crc16()
//        package.append(contentsOf:[UInt8(crcCode >> 8), UInt8(crcCode & 0xFF)])
        let newData = Data(package)
        return newData
    }
    
    var describe: String {
        let desStr = "transactId: \(transactId) command:\(command) functionType:\(functionType) stringData:\(stringData)"
        return desStr
    }
}

extension MGModbusPackage {
    enum MGModbusCommandType {
        /// 心跳
        case heartBeat
        /// 授权
        case authorization
        /// 订阅通知
        case notification
        ///
        case inquiry
        
        var modbusCommand: Command {
            var cmd:Command = .unkonw
            switch self {
            case .heartBeat:
                cmd = .readDiscreteInputs
            case .authorization:
                cmd = .readCoilStatus
            case .notification:
                cmd = .data_log_read
            case .inquiry:
                cmd = .data_log_read
            }
            return cmd
        }
    }
    
    /// MARK: - 查询Wifi名称
    static func inquiryDeviceWifiCommand() -> MGModbusPackage {
        let paraNum = 0x75
        let paraData = paraNum.data
        let cmd = MGModbusPackage(functionType: .inquiry, data: paraData)
        return cmd
    }
    
    static func setWifiPwdCommand() -> MGModbusPackage {
        let password:String = "Growatt88888"
        let paraData = password.data(using: .utf8)!
        let cmd = MGModbusPackage(functionType: .inquiry, data: paraData)
        return cmd
    }
    
    /// MARK: - 心跳
    static func heartbeatCommand() -> MGModbusPackage {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd_HH:mm"
        let datetimeString = dateformat.string(from: Date())
        let datetimeData = datetimeString.data(using: .utf8)!
        let cmd = MGModbusPackage(functionType: .heartBeat, data: datetimeData)
        return cmd
    }
}
