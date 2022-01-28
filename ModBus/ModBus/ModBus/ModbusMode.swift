//
//  Model.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/20.
//

/// Describe the format of sended package
enum ModbusMode {
    case tcp
    case rtu
    //case ascii
}

/// CRC mode (just in .rtu/.ascii modes)
enum CrcMode {
    //case crcNone
    //case crc8
    //case crc16
    case crc16modbus
    //case crc32
}


/**
 Modbus command codes
 - Coil:        One bit read/write register
 - Discrete:    One bit only read register
 - Holding:     16 bit read/write unsigned register
 - Input:       16 bit only read unsigned register
 */
enum Command: UInt8 {
    /** Read coil (one bit) register */
    case readCoilStatus = 0x01
    /** Read discrete (one bit) register */
    case readDiscreteInputs = 0x02
    /** Read holding (16 bit) register */
    case readHoldingRegisters = 0x03
    /** Read input (16 bit) register */
    case readInputRegisters = 0x04

    /** Write coil (one bit) register */
    case forceSingleCoil = 0x05
    /** Write holding (16 bit bit) register */
    case presetSingleRegister = 0x06

    /** Write multiply coil (one bit) registers */
    case forceMultipleCoils = 0x0F
    /** Write multiply holding (16 bit bit) registers */
    case presetMultipleRegisters = 0x10
    
    ///该功能码为完全透传命令：由手机app发送该命令码，数据采集器收到该命令码后，取出“透传数据区”，不作协议转换地透传给光伏设备；同时，对光伏设备返回的数据同样不作任何解析，直接当作“透传数据区”封装在MODBUS_TCP协议中响应给网络服务器。该命令并不局限于数据查询，还可以进行数据设置；也并不局限于对逆变器适用，对其它通过数据采集器与手机app相连的光伏设备同样适用，只要光伏设备能够解析出“透传数据区”中的内容，同时手机app也能解析出响应命令中“透传数据区”中的内容即可。
    case viaTransmission = 0x17
    
    /// 该功能码是手机app与数据采集器之间的命令，它用于手机app对数据采集器的相关参数进行设置，一次可对单/多个参数进行设置。数据采集器在收到手机app的该功能码后，需判断命令的合法性，然后执行对应的设置操
    case data_log_write = 0x18
    /// 该功能码是手机app与数据采集器之间的命令，它用于手机app对数据采集器的相关参数进行读取，一次可对单/多个参数进行读取。数据采集器在收到手机app的该功能码后，需判断命令的合法性，然后执行对应的设置操
    case data_log_read = 0x19
    
    ///该功能码是网络服务器给采集器下发文件用于采集器或逆变器升级。目前仅WIFI-S/WIFI-X类型采集器采用此方式。流程逻辑：1、设置采集器为升级模式；2、查询采集器需要的升级文件类型；3、发送升级文件包：服务器以0x26开始文件传输-->完成后；按原有升级流程采集器.
    case data_log_server = 0x26
    
    case unkonw
}

/**
 Modbus error codes
 */
enum ModError: UInt16 {
    case errorReadCoilStatus = 0x01 // read-write
    case errorReadDiscreteInputs = 0x02 // read only
    case errorReadHoldingRegisters = 0x03 // read-write
    case errorReadInputRegisters = 0x04 // read only
    
    case errorRorceSingleCoil = 0x05
    case errorPresetSingleRegister = 0x06
    
    case errorForceMultipleCoils = 0x15
    case errorPresetMultipleRegisters = 0x16
}


/**
 Modbus crc16 caluculator
 */
class Crc16 {
    
    func modbusCrc16(_ data: [UInt8]) -> UInt16? {
        if data.isEmpty {
            return nil
        }
        let polynomial: UInt16 = 0xA001 // A001 is the bit reverse of 8005
        var accumulator: UInt16 = 0xFFFF
        for byte in data {
            var tempByte = UInt16(byte)
            for _ in 0 ..< 8 {
                let temp1 = accumulator & 0x0001
                accumulator = accumulator >> 1
                let temp2 = tempByte & 0x0001
                tempByte = tempByte >> 1
                if (temp1 ^ temp2) == 1 {
                    accumulator = accumulator ^ polynomial
                }
            }
        }
        return accumulator
    }
    
}
