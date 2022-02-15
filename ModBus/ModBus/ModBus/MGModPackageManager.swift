//
//  MGModPackageManager.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

/// 采集返回的wifi信息
typealias MGDAU_Wifi_Info = (String, Int)

struct MGModPackageManager {
    
    static func unpackDAUPackage(withResponse data: Data) -> MGModbusPackage? {
        if data.count > 6 {
            let command = ModCommand(rawValue: Array(data)[7]) ?? .unkonw
            if command == .DAU_read {
                
                if let rPackage = try? MGDAUReadPackage(responseData: data) {
                    return rPackage
                }
            } else if command == .DAU_write {
                if let wPackage = try? MGDAUWritePackage(responseData: data) {
                    return wPackage
                }
            } else if command == .DAU_via {
                
            }
        }
        return nil
    }
    
    /// 0x19 功能码为75 的包中解析设备搜索到的wifi列表
    static func unpackDAUWifiList(from package: MGDAUReadPackage) -> [MGDAU_Wifi_Info]? {
        var dau_wifi_list: [MGDAU_Wifi_Info] = []
        print("count: \(package.parasCount), params: \(package.params)")
        if package.params.keys.contains(.wifiList) {
            if let wifiData = package.params[.wifiList] as? Data {
                let wDataArray: [UInt8] = Array(wifiData)
                let wifiCount:UInt8 = wDataArray[0]
                
                var point = 1 // 序列号，参数编号个数和状态码之后
                while point < wDataArray.count {
                    let nameLen = wDataArray[point]
                    guard wDataArray.count > point+Int(nameLen) else {return nil}
                    let nameData = wDataArray[point+1...point+Int(nameLen)]
                    let rssi = wDataArray[point+Int(nameLen)+1]
                    
                    let wifiName = String(data: Data(nameData), encoding: .utf8) ?? ""
                    let wifi: MGDAU_Wifi_Info = (wifiName, Int(rssi))
                    
                    dau_wifi_list.append(wifi)
                    
                    point = point+Int(nameLen)+2
                }
                print("DAU wifi List : \(dau_wifi_list)")
                
                if wifiCount == dau_wifi_list.count {
                    print("wifi列表 解析正常！")
                } else {
                    print("wifi列表 解析wifi个数不一致！")
                }
                
                return dau_wifi_list
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
