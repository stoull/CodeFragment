//
//  MGModbus.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/20.
//

import Foundation
import CryptoSwift
import BigInt

class MGModbus {
    private var slaveAdress: UInt8 = 0x01
    
    /// Just for .tcp mode
    private var transactId: UInt16 = 0x00
    /// Just for .tcp mode
    private var protocolId: UInt16 = 0x0005
    
    var crc16Table: [UInt16] = []
    
    convenience init(with parame: Bool) {
        self.init()
        self.crc16Table = (0...255).map { byteValue in
            crc16(for: byteValue, polynomial: 0x1021)
            }
    }
    
    // MARK: - 心跳
    func heartbeatCommand() -> Data {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd_HH:mm"
        let datetimeString = dateformat.string(from: Date())
        let datetimeData = datetimeString.data(using: .utf8)!
        return createCommand(command: .readDiscreteInputs, data: Array(datetimeData))
    }
    
    /// 创建modbus命令
    func createCommand(command: ModCommand, data: [UInt8]) -> Data {
        var package = [UInt8]()
        
        // mbap in tcp mode
        let lenght = 4 + data.count
        package.append(contentsOf: [UInt8(transactId >> 8), UInt8(transactId & 0xFF)])
        package.append(contentsOf: [UInt8(protocolId >> 8), UInt8(protocolId & 0xFF)])
        package.append(contentsOf: [UInt8(lenght >> 8), UInt8(lenght & 0xFF)])  // 从下一字节到最后一个字节的长度
        transactId += 1
        package.append(slaveAdress)    // 地址位 Unit ID
        package.append(command.rawValue)   // Function Code
//        package.append(contentsOf: [UInt8(address >> 8), UInt8(address & 0xFF)])
        package.append(contentsOf: data)
//        let crcCode = data.crc16()
//        package.append(contentsOf:[UInt8(crcCode >> 8), UInt8(crcCode & 0xFF)])
        let data = Data(package)
        return data
    }

    // MARK: - CRC16
    func getCRC16(dataBytes: [UInt8]) -> UInt16 {
        return dataBytes.crc16()
    }

    // MARK: 数据区循环异或秘钥
    func XOR(data:[UInt8], key: String) {
        var index: Int = 0
        var result:[UInt8]=[]
        let utf8Key = Array(key.utf8.map({UInt8($0)}))
        for bt in data {
            if index == key.count{
                index = 0
            }
            result.append(bt^utf8Key[index])
            index+=1
        }
    }
    
    // MARK: - CBC
    func encryptCBC(data: Data) {
        if let encrypted = try? Blowfish(key: "_growatt_datalog", iv: "", padding: .pkcs7) {
            
        }
    }
    
    // MARK: - xor加密
    
    func encrypt(str:String, key:BigUInt)->String
    {
        let value = BigUInt(str.data(using: String.Encoding.utf8)!)
        let encrypt = key ^ value
        return String(encrypt, radix: 16)
    }

    func decrypt(str:String, key:BigUInt)->String
    {
        let value = BigUInt(str, radix: 16)!
        let decrypt = key ^ value
        return String(data: decrypt.serialize(), encoding: String.Encoding.utf8)!
    }
    
    
    // MARK: - CRC 16
    func crc16(for inputs: [UInt8], initialValue: UInt16 = 0x00) -> UInt16 {
        inputs.reduce(initialValue) { remainder, byte in
            let bigEndianInput = UInt16(byte) << 8
            let index = (bigEndianInput ^ remainder) >> 8
            return crc16Table[Int(index)] ^ (remainder << 8)
        }
    }
    
    func crc16(for input: UInt16, polynomial: UInt16) -> UInt16 {
        let result = UInt16(input).bigEndian
        return (0..<8).reduce(result) { result, _ in
            let isMostSignificantBitOne = result & 0x8000 != 0
            guard isMostSignificantBitOne else {
                return result << 1
            }
            return (result << 1) ^ polynomial
        }
    }
    
}
