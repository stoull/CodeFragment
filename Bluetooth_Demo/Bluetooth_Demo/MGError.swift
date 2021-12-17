//
//  MGError.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import Foundation

class MGError: Error {
    static let kCanNotFindBTLEDeviceInfo: String = "找不到蓝牙信息"
    var message: String = ""
    var code: Int = 0
    
    init(message: String?, code: Int) {
        self.message = message ?? "未知错误"
        self.code = code
    }
}



// MARK: - 延迟执行
func sw_dispatchOnMainQueueAfter(_ time: Double, block: @escaping ()->()) {
    let dispatchTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: block)
}
