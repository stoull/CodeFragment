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
    
    init(peripheral: CBPeripheral, advertisementData: [String: Any]) {
//        if let rName = peripheral.name {
//            self.name = rName
//        } else
        if let lName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            self.name = lName
        } else {
            self.name = ""
        }
        
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
