//
//  MGPenetrateModPackage.swift
//  ModBus
//
//  Created by Hut on 2022/2/11.
//

import Foundation

/// 命令码0x17 透传给机器在的的modbus数据包 详见 文档"Growatt PV Inverter Modbus RS485 RTU Protocol V3.13--中文客户版.docx"
protocol MGPenetrateModBus: AnyObject {
    /// 从机地址
    var slaveAddress: UInt8 { get set}
    /// 寄存器类型或对寄存器功能类型
    var registerTypeOrFunction: UInt8 { get set}
    /// 寄存器开始位置
    var registerStartAddress: UInt16 { get set}
    /// 寄存器开始位置
    var registerCount: UInt16 { get set}
    /// 字节数目 (设置数据或读取到的数据的字节长度)
    var dataByteCount: UInt8 { get set}
    /// 设置数据或读取到的数据
    var data: [UInt16]? { get set}
    /// CRC校验 值
    var CRC: UInt16 { get set}
}

extension MGPenetrateModBus {
    func asData() -> Data {
        var dataArray: [UInt8] = [slaveAddress, registerTypeOrFunction]
        dataArray.append(contentsOf: [UInt8(registerStartAddress >> 8), UInt8(registerStartAddress & 0xFF)])
        dataArray.append(contentsOf: [UInt8(registerCount >> 8), UInt8(registerCount & 0xFF)])
        
        let type = MGRTURegisterActionType(rawValue: registerTypeOrFunction)
        if type == .read_holding || type == .read_input {
            
        } else if type == .set_register {
            if let sData = data {
                var dataArray: [UInt8] = []
                for iData in sData {
                    dataArray.append(contentsOf: [UInt8(iData >> 8), UInt8(iData & 0xFF)])
                }
            }
            dataArray.append(contentsOf: dataArray)
        }  else if type == .set_withMultipleRegister {
            /// 字节数目
            dataArray.append(dataByteCount)
            
            /// 数据
            if let sData = data {
                var dataArray: [UInt8] = []
                for iData in sData {
                    dataArray.append(contentsOf: [UInt8(iData >> 8), UInt8(iData & 0xFF)])
                }
            }
            dataArray.append(contentsOf: dataArray)
        }
        CRC = getCrc16(data: Data(dataArray))
        dataArray.append(contentsOf: [UInt8(CRC >> 8), UInt8(CRC & 0xFF)])
        return Data(dataArray)
    }
    
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
}

/// Remote terminal unit 设备寄存器类型
enum MGRTURegisterActionType: UInt8 {
    /// 读holding寄存器
    case read_holding = 3
    /// 读input寄存器
    case read_input = 4
    /// 设置寄存器
    case set_register = 6
    /// 预设值有多个寄存器
    case set_withMultipleRegister = 16
}

/// 命令码0x17 透传给机器在的的modbus数据包 详见 文档"Growatt PV Inverter Modbus RS485 RTU Protocol V3.13--中文客户版.docx"
class MGPenetrateModPackage: MGPenetrateModBus {
    /// 从机地址
    var slaveAddress: UInt8
    /// 寄存器类型或对寄存器功能类型
    var registerActionType: MGRTURegisterActionType
    var registerTypeOrFunction: UInt8 {
        get {return registerActionType.rawValue}
        set { registerActionType = MGRTURegisterActionType(rawValue: newValue) ?? MGRTURegisterActionType.read_holding}
    }
    /// 寄存器开始位置
    var registerStartAddress: UInt16
    /// 寄存器开始位置
    var registerCount: UInt16
    /// 字节数目 (设置数据或读取到的数据的字节长度)
    var dataByteCount: UInt8 = 0
    /// 设置数据或读取到的数据
    var data: [UInt16]?
    /// CRC校验 值
    var CRC: UInt16
    
    init(slaveAddress: UInt8, registerTypeOrFunction type: MGRTURegisterActionType, startAddress:UInt16, count: UInt16, setData:[UInt16]?){
        self.slaveAddress = slaveAddress
        self.registerActionType = type
        self.registerStartAddress = startAddress
        self.registerCount = count
        
        if let sData = setData {
            self.dataByteCount = UInt8(sData.count)
            self.data = sData
        } else {
            self.data = nil
        }
        // 在fl
        self.CRC = 0
    }
    
    /**
     根据采集器返回的数据，生成包对象
     - Parameter para1: responseData 采集器响映的查询数据
     */
    init(responseData: Data) throws{
        let dataArray = Array(responseData)
        guard dataArray.count > 4 else { throw MGModBusError(type: .dataError)}
        slaveAddress = dataArray[0]
        registerActionType = MGRTURegisterActionType(rawValue: dataArray[1]) ?? .read_holding
        registerStartAddress = Data(dataArray[2...3]).uint16
        
        let type = self.registerActionType
        if type == .read_holding ||
            type == .read_input {
            self.data = []
            self.dataByteCount = dataArray[2]
            let dataCount = self.dataByteCount%2
            var dPoint: Int = 3
            for _ in 1...dataCount {
                self.data?.append(Data(dataArray[dPoint...dPoint+1]).uint16)
                dPoint = dPoint + 2
            }
        } else if type == .set_withMultipleRegister {
            self.data = []
            self.dataByteCount = dataArray[2]
            let dataCount = self.dataByteCount%2
            var dPoint: Int = 3
            for _ in 1...dataCount {
                self.data?.append(Data(dataArray[dPoint...dPoint+1]).uint16)
                dPoint = dPoint + 2
            }
        } else if type == .set_register {
            self.data = [Data(dataArray[3...4]).uint16]
            self.dataByteCount = 2
        } else {
            self.data = []
            self.dataByteCount = 0
        }
        self.registerCount = UInt16(self.dataByteCount)
        CRC = Data(dataArray[dataArray.count-2...dataArray.count-1]).uint16
    }
}
