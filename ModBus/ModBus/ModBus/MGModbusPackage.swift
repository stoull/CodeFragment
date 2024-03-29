//
//  MGModbusPackage.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/21.
//

import Foundation
import CryptoSwift
import BigInt

let k_MGDAU_XOR_KEY: String = "Growatt"

/// 协议采集器序列号长度
let k_MGDAU_serialNumber_lenthg: Int = 10 // 10位，服务器对采集器为30位

class MGModbusPackage {
    var modMode: ModbusMode = .tcp
    
    /// 事务处理标识 仅tcp mode下有
    var transactId: UInt16 = 0x0001
    /// 协议标识符 00 00表示ModbusTCP协议 仅tcp mode下有
    var protocolId: UInt16 = 0x0005
    /// 数据长度
    var length: UInt16 = 0x00
    /// 单元标识符 可以理解为设备地址
    var slaveAdress: UInt8 = 0x01
    
    /// 对应的 ‘功能码’
    var command: ModCommand = .unkonw
    
    /// 对应的数据区的自定 ‘参数编号’
    var validData: Data?
    
    var crc16Table: [UInt16] = []
    
    init(command: ModCommand, validData: Data, transactId:UInt16 = 0x0001) {
        self.command = command
        self.transactId = transactId
        
        self.validData = validData
        self.length = UInt16(validData.count)
        
        self.crc16Table = (0...255).map { byteValue in
            crc16(for: byteValue, polynomial: 0x1021)
        }
    }
    
    /// 解析从设备过来的data, 需要解密码及crc验证
    init(modbusPackage data: Data) throws {
        let dataArray = Array(data)
        guard dataArray.count > 8 else {
            throw MGModBusError(type: .dataError)
        }
        
        let sCRC = Data(dataArray[dataArray.count-2...dataArray.count-1]).uint16
        let checkData = Data(dataArray[0...dataArray.count-3])
        let rCrc = getCrc16(data: checkData, seed: 0xFFFF)
        guard sCRC == rCrc else { print("CRC校验失败 "); throw MGModBusError(type: .dataError)}
        
//        let result = (UInt16(bytes[1]) << 8) + UInt16(bytes[0])
        self.transactId = Data(dataArray[0...1]).uint16
        self.protocolId = Data(dataArray[2...3]).uint16
        let lenght = Data(dataArray[4...5]).uint16
        self.length = lenght
        self.slaveAdress = dataArray[6]
        self.command = ModCommand(rawValue: dataArray[7]) ?? .unkonw
        let crypData = Data(dataArray[8...Int(8+length-3)])
        self.validData = XOR(data: crypData, key: k_MGDAU_XOR_KEY)
    }
    
    var asData: Data {
        if let validData = self.validData {
            // 数据区加密(循环异或秘钥)
            let xorkey = k_MGDAU_XOR_KEY
            let cryptData = self.XOR(data: validData, key: xorkey)
            
            let cmdData = createCommand(command: self.command, data: Array(cryptData))
//            print("as cmd data: \(cmdData.hexEncodedString())")
            return cmdData
        } else {
            let cmdData = createCommand(command: self.command, data: Array())
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
    private func createCommand(command: ModCommand, data: [UInt8]) -> Data {
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
//        let crcCode = Data(package).crc16()
        let oldCrc = getCrc16(data: Data(package), seed: 0xFFFF)
        
        package.append(contentsOf:[UInt8(oldCrc >> 8), UInt8(oldCrc & 0xFF)])
        let newData = Data(package)
        return newData
    }
    
    
    func generateDataPart(withCmd: MGModbusCommandType) {
        
    }
    
    var describe: String {
        let desStr = "transactId: \(transactId) command:\(command) stringData:\(stringData)"
        return desStr
    }
    
    // MARK: - CRC16
    func getCRC16(dataBytes: [UInt8]) -> UInt16 {
        return dataBytes.crc16()
    }

    // MARK: 数据区循环异或秘钥
    func XOR(data: Data, key: String) -> Data {
        var index: Int = 0
        var result:[UInt8]=[]
        let utf8Key = Array(key.utf8.map({UInt8($0)}))
        let dataArray = Array(data)
        for bt in dataArray {
            if index == key.count{
                index = 0
            }
            result.append(bt^utf8Key[index])
            index+=1
        }
        return Data(result)
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
    func crc16(for inputs: [UInt8], initialValue: UInt16 = 0xFFFF) -> UInt16 {
        inputs.reduce(initialValue) { remainder, byte in
            let bigEndianInput = UInt16(byte) << 8
            let index = (bigEndianInput ^ remainder) >> 8
            return crc16Table[Int(index)] ^ (remainder << 8)
        }
    }
    
    func crc16(for input: UInt16, polynomial: UInt16) -> UInt16 {
        let result = UInt16(input).bigEndian
        return (0..<8).reduce(result) { result, _ in
            let isMostSignificantBitOne = result & 0x0001 != 0
            guard isMostSignificantBitOne else {
                return result << 1
            }
            return (result << 1) ^ polynomial
        }
    }
    
    /// 专设备
    func getCrc16(data: Data, seed: UInt16 = 0xFFFF) -> UInt16 {
        var crcWord:UInt16 = seed
        let dataArray = Array(data)
        dataArray.forEach { byte in
            crcWord ^= UInt16(byte) & 0xFFFF
            (0...7).forEach { _ in
                if (crcWord & 0x0001) == 1 {
                    crcWord = crcWord>>1
                    crcWord = crcWord^0xA001
                } else {
                    crcWord = crcWord>>1
                }
            }
        }
        let crcH = UInt8(0xff&(crcWord>>8))
        let crcL = UInt8(0xff&crcWord)
        let crcUnit16 = Data([crcH, crcL]).withUnsafeBytes { $0.load(as: UInt16.self) }
        return crcUnit16.bigEndian
    }
    
    // 采集器端代码
    /**
     /*******************************************************************************
     * 函数名: crc16_ccitt
     * 功  能: crc校验
     * 输  入: *Buff：校验数组  nSize：校验数组长度
     * 输  出: none
     * 返回值: crc：校验结果
     * 注  意:  ＾（异或运算）
     *******************************************************************************/
     unsigned short int  Modbus_Caluation_CRC16(unsigned char *Buff, unsigned int nSize)
     {
         unsigned short int m_Crc = 0;
         unsigned short int i = 0,j = 0;
         unsigned short int m_InitCrc = 0xFFFF;

         for(i=0; i<nSize; i++)
         {
             m_InitCrc ^= Buff[i];
             for(j=0; j<8; j++)
             {
                 m_Crc = m_InitCrc;
                 m_InitCrc >>= 1;
                 if(m_Crc&0x0001)
                 {
                     m_InitCrc ^= 0xa001;
                 }
             }
         }
         return m_InitCrc;
     }
     
     /*****************************************
         发送服务器数据 协议异或
         6.0 版本协议
     ******************************************/
     #define GRT_KEY_LEN        7
     const char GrowattKey[GRT_KEY_LEN] = {'G', 'r', 'o', 'w', 'a', 't', 't'};
     uint8_t encrypt(uint8_t *pdata, uint16_t length)
     {
         uint8_t i = 0;
         if(length >= ServerProtocolMAXSIZE)
         {
             return 1;
         }
         while(length--)
         {
             *pdata++ ^= GrowattKey[i++];
             if(i == GRT_KEY_LEN)
                 i = 0;
         }
         return 0;
     }
     */
}
