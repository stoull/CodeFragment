//
//  MGBTLEDevice.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import Foundation
import CoreBluetooth

class MGBTLEDevice: Equatable {
    var name: String = ""
    
    var peripheral: CBPeripheral?
    
    var rssi: Int = 0
    
    init(peripheral: CBPeripheral, rssi: Int, advertisementData: [String: Any]) {
//        if let rName = peripheral.name {
//            self.name = rName
//        } else
        if let lName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            self.name = lName
        } else {
            self.name = ""
        }
        
        if let uuidArray = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            print("has CBAdvertisementDataServiceUUIDsKey  uuid: \(uuidArray)")
            for uuid in uuidArray {
                print("discoverd serverice uuid: \(uuid.uuidString)")
            }
            if uuidArray.count == 0 {
                print("device has no service count 0")
            }
        } else {
            print("device has no service")
        }
        
        self.rssi = rssi
        self.peripheral = peripheral
    }
    
    static func == (lhs: MGBTLEDevice, rhs: MGBTLEDevice) -> Bool {
        if let lshPer = lhs.peripheral, let rhsPer = rhs.peripheral {
            return lshPer.identifier == rhsPer.identifier
        } else {
            return lhs.name == rhs.name
        }
    }
}
