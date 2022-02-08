//
//  MGDataloggerParameter.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation
import SwiftUI

/// 读写属性
enum MGDAURWAttributes {
    case onlyWrite
    case onlyRead
    case readAndWrite
    case noneReadAndWrite
}

/// 采集器参数 详见 Growatt数服协议7.0.0.doc
enum MGDAUParameter {
    case unknow
    
    /// 数据采集器向网络服务器传送数据的间隔时间，单位为分钟
    case dataInterval
    /// 数据采集器序列号
    case dataloggerSN
    /// 数据采集器类型
    case dataloggerType
    /// 数据采集器的本端IP地址
    case ip
    /// 数据采集器的远端（网络服务器）IP地址
    case host_ip
    /// 数据采集器连入互联网的网卡MAC地址
    case mac
    /// 数据采集器的远端（网络服务器）端口
    case host_port
    /// 数据采集器的远端（网络服务器）域名
    case host_domain
    /// 数据采集器的固件版本
    case firmwareVersion
    /// 数据采集器的硬件版本
    case hardwareVersion
    /// 数据采集器的子网掩码
    case subnetMask
    /// 数据采集器的默认网关
    case defaultGateway
    /// 数据采集器的系统时间
    case systemTime
    /// 数据采集器重启标识
    case dataloggerRestart
    /// WIFI 模块要链接热点名称
    case wifi_SSID
    /// WIFI 模块要链接的热点密钥
    case wifi_password
    /// WiFi连接状态
    case wifi_lineStatus
    /// WiFi升级文件类型
    case fotaFileType
    /// DHCP使能
    case DHCP
    /// 获取周围路由WiFi名字
    case wifiList
    
    /// 参数编号
    var number: UInt8 {
        return localizedInfo.number
    }
    
    var name: String {
        return localizedInfo.name
    }
    
    var rwAttributes: MGDAURWAttributes{
        return localizedInfo.RWAttributes
    }
    
    var localizedInfo:(number: UInt8, name: String, RWAttributes:MGDAURWAttributes) {
        var sNum: UInt8 = 00
        var sName: String = ""
        var sRW: MGDAURWAttributes = .readAndWrite
        switch self {
        case .dataInterval:
            sNum = 4
            sName = "Data Interval"
        case .dataloggerSN:
            sNum = 8
            sName = "Datalogger SN"
        case .dataloggerType:
            sNum = 13
            sName = "Datalogger Type"
        case .ip:
            sNum = 14
            sName = "Local IP"
        case .host_ip:
            sNum = 16
            sName = "Local Mac"
            sRW = .onlyRead
        case .mac:
            sNum = 17
            sName = "Remote IP"
        case .host_port:
            sNum = 18
            sName = "Remote Port"
        case .host_domain:
            sNum = 19
            sName = "Remote URL"
        case .firmwareVersion:
            sNum = 21
            sName = "Firmware Version"
            sRW = .onlyRead
        case .hardwareVersion:
            sNum = 22
            sName = "Hardware Version "
            sRW = .onlyRead
        case .subnetMask:
            sNum = 25
            sName = "SubnetMask"
        case .defaultGateway:
            sNum = 26
            sName = "DefaultGateway"
        case .systemTime:
            sNum = 31
            sName = "System Time"
        case .dataloggerRestart:
            sNum = 32
            sName = "Datalogger Restart"
        case .wifi_SSID:
            sNum = 56
            sName = "WiFi SSID"
        case .wifi_password:
            sNum = 57
            sName = "WiFi Password"
        case .wifi_lineStatus:
            sNum = 60
            sName = "Link status"
            sRW = .onlyRead
        case .fotaFileType:
            sNum = 65
            sName = "Fota File Type"
            sRW = .onlyRead
        case .DHCP:
            sNum = 71
            sName = "Net DHCP"
        case .wifiList:
            sNum = 75
            sName = "get router name"
        case .unknow:
            sNum = 255
            sName = "unknow"
        }
        
        return (sNum, sName, sRW)
    }
    
    /// 将参数编号转成对应的model
    static func from(parameterNumber: UInt16) -> MGDAUParameter {
        var para: MGDAUParameter = .unknow
        if parameterNumber == 4 {
            para = .dataInterval
        } else if parameterNumber == 8 {
            para = .dataloggerSN
        } else if parameterNumber == 13 {
           para = .dataloggerType
        } else if parameterNumber == 14 {
           para = .ip
        } else if parameterNumber == 16 {
           para = .host_ip
        } else if parameterNumber == 17 {
           para = .mac
        } else if parameterNumber == 18 {
           para = .host_port
        } else if parameterNumber == 19 {
           para = .host_domain
        } else if parameterNumber == 21 {
           para = .firmwareVersion
        } else if parameterNumber == 22 {
           para = .hardwareVersion
        } else if parameterNumber == 25 {
           para = .subnetMask
        } else if parameterNumber == 26 {
           para = .defaultGateway
        } else if parameterNumber == 31 {
           para = .systemTime
        } else if parameterNumber == 32 {
           para = .dataloggerRestart
        } else if parameterNumber == 56 {
           para = .wifi_SSID
        } else if parameterNumber == 57 {
           para = .wifi_password
        } else if parameterNumber == 60 {
           para = .wifi_lineStatus
        } else if parameterNumber == 65 {
           para = .fotaFileType
        } else if parameterNumber == 71 {
           para = .DHCP
        } else if parameterNumber == 75 {
           para = .wifiList
        }
        return para
    }
}
