//
//  TransferService.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import Foundation
import CoreBluetooth



struct MGTransferService {
    static let serviceUUID = CBUUID(string: "00FF")  // 0x00EE
    static let characteristicUUID = CBUUID(string: "FF01")
    
//    static let serviceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
//    static let characteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
    
    
    static let service_eeUUID = CBUUID(string: "00EE")  // 0x00EE
    static let service_ffUUID = CBUUID(string: "00FF")  // 0x00EE
    static let characteristic_eeUUID = CBUUID(string: "EE01") // 0xEE01
    static let characteristic_ffUUID = CBUUID(string: "FF01") // 0xFF01
    
    // UInt16 转string
    func convertUInt16ToString() {
        let ee_uuid: UInt16 = 0x00EE
        let ee_uuidStr = String(format:"%04x",ee_uuid)
        let eeUUID = CBUUID(string: ee_uuidStr)
    }
}
