//
//  MGDAUPackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

struct MGModBusError: Error {
    var type: MGModBusStatusType = .unknow
    var code: UInt8 = 0
    var message: String = ""
    
    init(type: MGModBusStatusType) {
        self.init(type: type, code: type.rawValue, message: type.message)
    }
    
    init(type: MGModBusStatusType, code: Int, message: String) {
        self.type = type
        self.code = code
        self.message = message
    }
}

enum MGModBusStatusType: UInt8 {
    case unknow = 0xff
    
    // 接口层
    
    /// 成功
    case successs = 0x00
    /// 数据不合法 数据格式错误
    case dataError = 0x01
    
    
    // app 层
    
    /// 数据格式错误
    case commandTypeError
    
    var message: String {
        switch self {
        case .unknow:
            return "未知错误"
        case .successs:
            return "成功"
        case .dataError:
            return "数据格式错误"
        case .commandTypeError:
            return "modbus command（功能码）与要转成的对象类型不一致"
        }
    }
}

class MGDAUPackage: MGModbusPackage {
    
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
        case read
        
        case write
        
        var modbusCommand: ModCommand {
            var cmd:ModCommand = .unkonw
            switch self {
            case .heartBeat:
                cmd = .readDiscreteInputs
            case .authorization:
                cmd = .readCoilStatus
            case .notification:
                cmd = .DAU_read
            case .read:
                cmd = .DAU_read
            case .write:
                cmd = .DAU_write
            }
            return cmd
        }
    }
    
    /// MARK: - 查询Wifi名称
    static func inquiryDeviceWifiCommand() -> MGModbusPackage {
        let paraNum = 0x75
        let paraData = paraNum.data
        let cmd = MGModbusPackage(functionType: .read, data: paraData)
        return cmd
    }
    
    static func setWifiPwdCommand() -> MGModbusPackage {
        let password:String = "Growatt88888"
        let paraData = password.data(using: .utf8)!
        let cmd = MGModbusPackage(functionType: .read, data: paraData)
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
