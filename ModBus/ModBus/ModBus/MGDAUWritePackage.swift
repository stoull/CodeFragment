//
//  MGDAUWritePackage.swift
//  ModBus
//
//  Created by Hut on 2022/1/28.
//

import Foundation

class MGDAUWritePackage: MGModbusPackage {
    static func writePackage(with commandType: MGModbusCommandType, parameter: MGDAUParameter, data: Data) -> MGModbusPackage {
        let paraNum = parameter.number
        let paraData = paraNum.data
        let cmd = MGModbusPackage(functionType: .read, data: paraData)
        return cmd
    }
}
