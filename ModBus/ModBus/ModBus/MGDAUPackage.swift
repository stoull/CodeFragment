//
//  MGDAUPackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

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
