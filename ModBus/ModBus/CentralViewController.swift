//
//  ViewController.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import UIKit
import CoreBluetooth
import os
import SwiftUI


class CentralViewController: UIViewController {
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var writeDataTextView: UITextView!
    @IBOutlet weak var connectStatusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var discoveredDevice: [MGBTLEDevice] = []
    var btleManager: MGBTLECentralManager = MGBTLECentralManager()
    
    var modbus = Modbus()
    var mgModbus = MGModbus()
    
    var bluetoothHelper: HSBluetoochManager!
    
    let deviceSerialNumber: String = "D0BSB19003" //"D0BSB19003"

    convenience init() {
        self.init(nibName: "CentralViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kBtCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        btleManager = MGBTLECentralManager(delegate: self)
        
        self.activityIndicatorView.isHidden = true
        
        
//        let string = "000100070022011902213F2028323D1F2A37776074740C72E77D660E1F33171C0350A17E57312520273545773B5F26514344774258A56B7F013410301212044C754459BC6B7820221C0B163E30357F302D47AA7E711317011300BE7E49263F5A2D3D3A0C2D2C4152443677B8657D2427241833594253464D8F786423041A10262D0C12121C1D81786723041A10265F5831A17E7813170113002B377F425D4750B41CA9"
//        var sSting = string
//        var resultS: String = ""
//        for i in 1...Int(string.count/2) {
//            let preS = sSting.prefix(2)
//            resultS.append("0x\(preS), ")
//            sSting.removeFirst()
//            sSting.removeFirst()
//        }
//        print(resultS)
    }
    
    func isBluetoothAuthorized() -> Bool {
        if #available(iOS 13.0, *) {
            return CBCentralManager().authorization == .allowedAlways
        }
        return CBPeripheralManager.authorizationStatus() == .authorized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isBluetoothAuthorized() {
            
        } else {
            
        }
        
        /// 测试-0x19参数读取操作
//        let dataArray: [UInt8] = [1,13,1,5,0,37,1,19,9,9,9,9,9,9,9,9,9,9,0,4,0,0,19,0,1,6,0,18,0,1,7,0,17,0,1,8,0,16,0,1,9,0,0]
//        let data = Data(dataArray)
//        do {
//            let readPackage = try MGDAUReadPackage(responseData: data)
//            let rData = readPackage.asData
//            print("测试0x19参数读取操作: ")
//            var index = 1
//            for (key,value) in readPackage.params {
//                print("参数 \(index): \(key.name) 编号: \(key.number)")
//                if let v = value {
//                    print("字节长度：\(v.count), 值：\(v.uint8)")
//                }
//                index += 1
//            }
//        } catch let error {
//            print("测试0x19参数读取操作错误: \(error)")
//        }
//
//
//        /// 测试-0x18参数设置操作
//        let dataArray_18: [UInt8] = [1,13,1,5,0,17,1,19,9,9,9,9,9,9,9,9,9,9,0,2,0,0,0]
//        let dataArray_18: [UInt8] = [0x00,0x01,0x00,0x05,0x00,0x23,0x01,0x18,0x26,0x13,0x0e,0x16,0x00,0x15,0x15,0x26,0x13,0x0e,0x77,0x60,0x74,0x67,0x47,0x39,0x6f,0x78,0x06,0x11,0x00,0x67,0x00,0x00,0x02,0x15,0x11,0x06,0x67,0x1c,0x0e,0x1a,0x04] //  00 01 00 05 00 23 01 18 26 13 0e 16 00 15 15 26 13 0e 77 60 74 67 47 39 6f 78 06 11 00 67 00 00 02 15 11 06 67 1c 0e 1a 04 8e 2f
////        let dataArray_18: [UInt8] = [0x00,0x01,0x00,0x05,0x00,0x21,0x01,0x18,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x00,0x01,0x00,0x13,0x00,0x4b,0x00,0x0f,0x67,0x65,0x74,0x20,0x72,0x6f,0x75,0x74,0x65,0x72,0x20,0x6e,0x61]
//        let data_18 = Data(dataArray_18)
//        do {
//            let readPackage = try MGDAUWritePackage(responseData: data_18)
//            let rData = readPackage.asData
//            print("0x18 Package data: \(rData.hexEncodedString().uppercased())")
//            if readPackage.code == .successs {
//                print("测试0x18参数设置操作 成功")
//            } else {
//                print("测试0x18参数设置操作 失败")
//            }
//        } catch let error {
//            print("测试0x18参数设置操作 失败 \(error)")
//        }
        
        print("测试-0x17参数设置操作")
        /// 测试-0x17参数设置操作
        /// 01 03 00 17 00 05 75 CC
//        let dataArray_17: [UInt8] = [1,3,00,23,0,5,117] // CRC: 75CC
        let rutPackage = MGPenetrateModPackage(slaveAddress: 1, registerTypeOrFunction: .read_holding, startAddress: UInt16(23), count: UInt16(5), setData: [UInt16(117)])
        let pdata = rutPackage.asData()
        print("Package data: \(pdata.hexEncodedString().uppercased())")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btleManager.cleanup()
    }

    // MARK: - Helper Methods
    @IBAction func test19Commnand(_ sender: Any) {
        
        let dataA: [UInt8] = [0x00, 0x01, 0x00, 0x07, 0x00, 0x9B, 0x01, 0x19, 0x02, 0x21, 0x3F, 0x20, 0x28, 0x32, 0x3D, 0x1F, 0x2A, 0x37, 0x77, 0x60, 0x74, 0x74, 0x0C, 0x72, 0xE7, 0x7D, 0x66, 0x0E, 0x1F, 0x33, 0x17, 0x1C, 0x03, 0x50, 0xA1, 0x7E, 0x57, 0x31, 0x25, 0x20, 0x27, 0x35, 0x45, 0x77, 0x3B, 0x5F, 0x26, 0x51, 0x43, 0x44, 0x77, 0x42, 0x58, 0xA5, 0x6B, 0x7F, 0x01, 0x34, 0x10, 0x30, 0x12, 0x12, 0x04, 0x4C, 0x75, 0x44, 0x59, 0xBC, 0x6B, 0x78, 0x20, 0x22, 0x1C, 0x0B, 0x16, 0x3E, 0x30, 0x35, 0x7F, 0x30, 0x2D, 0x47, 0xAA, 0x7E, 0x71, 0x13, 0x17, 0x01, 0x13, 0x00, 0xBE, 0x7E, 0x49, 0x26, 0x3F, 0x5A, 0x2D, 0x3D, 0x3A, 0x0C, 0x2D, 0x2C, 0x41, 0x52, 0x44, 0x36, 0x77, 0xB8, 0x65, 0x7D, 0x24, 0x27, 0x24, 0x18, 0x33, 0x59, 0x42, 0x53, 0x46, 0x4D, 0x8F, 0x78, 0x64, 0x23, 0x04, 0x1A, 0x10, 0x26, 0x2D, 0x0C, 0x12, 0x12, 0x1C, 0x1D, 0x81, 0x78, 0x67, 0x23, 0x04, 0x1A, 0x10, 0x26, 0x5F, 0x58, 0x31, 0xA1, 0x7E, 0x78, 0x13, 0x17, 0x01, 0x13, 0x00, 0x2B, 0x37, 0x7F, 0x42, 0x5D, 0x47, 0x50, 0xB4, 0x1C, 0xA9]
        
        typealias DAU_Wifi_Info = (String, Int)
        var dau_wifi_list: [DAU_Wifi_Info] = []
        if let cmd = try? MGDAUReadPackage(responseData: Data(dataA)) {
            if let wifiList = MGModPackageManager.unpackDAUWifiList(from: cmd) {
                print("获取到采集器wifi列表：\(wifiList)")
            } else {
                print("采集器wifi列表解析失败")
            }
        }
        

//        let cmd = MGDAUReadPackage(dauSerial: deviceSerialNumber, parameters: [.wifi_SSID]).asData
//
//        print("0x19 cmd Data: \(cmd.hexEncodedString().uppercased())")
//        btleManager.writeData(with: cmd)
    }

    @IBAction func test18Commnand(_ sender: Any) {
        
        /// 获取wifi列表信息
        let getWifiPara = "get router name".data(using: .utf8)!
        let cmd = MGDAUWritePackage(dauSerial: deviceSerialNumber, parameters: [.wifiList: getWifiPara]).asData
        
        /// 测试-设置wifi信息参数
//        let wifiName = "Growatt88888".data(using: .utf8)!
//        let wifiPwd = "wifipassword".data(using: .utf8)!
//        let cmd = MGDAUWritePackage(dauSerial: deviceSerialNumber, parameters: [.wifi_SSID: wifiName, .wifi_password: wifiPwd]).asData
        
        print("0x18 cmd Data: \(cmd.hexEncodedString().uppercased())")
        
        btleManager.writeData(with: cmd)
    }
    
    @IBAction func test17Commnand(_ sender: Any) {
        let rutPackage = MGPenetrateModPackage(slaveAddress: 12, registerTypeOrFunction: .read_holding, startAddress: 23, count: 1, setData: nil)
        let viaCmd = MGDAUPenetratePackage(dauSerial: deviceSerialNumber, penetratePackage: rutPackage).asData
        
        print("0x17 Cmd Data: \(viaCmd.hexEncodedString().uppercased())")
        
        btleManager.writeData(with: viaCmd)
    }
    
    @IBAction func searchButtonDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.activityIndicatorView.isHidden = false
            self.indicatorLabel.text = "搜索中...."
            self.activityIndicatorView.startAnimating()
            btleManager.scanPeripheral { device, error in
                if let error = error {
                    self.btleManager.stopScanPeripheral()
                    self.indicatorLabel.text = "搜索错误！:\(error.message)"
                    self.activityIndicatorView.stopAnimating()
                } else {
                    if self.discoveredDevice.contains(device!) == false {
                        self.discoveredDevice.append(device!)
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                    }
                }
            }
        } else {
            self.btleManager.stopScanPeripheral()
            self.indicatorLabel.text = "搜索完成！"
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
}

extension CentralViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredDevice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "kBtCell", for: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "kBtCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "kBtCell")
        }
        
        let device = discoveredDevice[indexPath.row]
        cell!.textLabel?.text = device.name
        cell!.detailTextLabel?.text = String(device.rssi)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sDevice = self.discoveredDevice[indexPath.row]
        print("Did selected device: \(sDevice)")
        self.connectStatusLabel.text = "连接中...."
        self.btleManager.connectTo(device: sDevice) { device, error in
            if let error = error {
                print("btleManager connectTo device error \(error.message)")
                self.connectStatusLabel.text = "连接失败：\(error.message)"
            } else {
                print("btleManager connectTo device successful")
                self.connectStatusLabel.text = "连接成功！"
                self.btleManager.discoverServices(for: sDevice, serviceUUIDs: [MGTransferService.serviceUUID])
            }
        }
    }
}


extension CentralViewController: MGBTLECentralManagerDelegate {
    func centralManager(manager: MGBTLECentralManager, connectionStatusDidChange status: MGBTLECentralConnectionStatus) {
        self.connectStatusLabel.text = status.rawValue
    }
    
    func centralManager(manager: MGBTLECentralManager, didWriteData data: Data, for peripheral: CBPeripheral, error: Error?) {
        print("写入数据成功: \(data.hexEncodedString().uppercased())")
        writeDataTextView.text = writeDataTextView.text + "\n" +  data.hexEncodedString().uppercased()
    }
    
    func centralManager(manager: MGBTLECentralManager, didDisconnectDevice peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(manager: MGBTLECentralManager, didRecievedData data: Data) {
        print("特征数据接收:")
//        let modCmd = MGModbusCommand(with: data)
        
        let rawDataHex = data.hexEncodedString().uppercased()
        print("Recieved 特征数据: \(rawDataHex)")
        
        textView.text = textView.text + "\n" + "Raw Data: " + rawDataHex
        
        if let package = MGModPackageManager.unpackDAUPackage(withResponse: data) {
            if package.command == .DAU_read,
               let wPackage = package as? MGDAUReadPackage {
                
                if let wifiList = MGModPackageManager.unpackDAUWifiList(from: wPackage) {
                    print("获取到采集器wifi列表：\(wifiList)")
                } else {
                    print("采集器wifi列表解析失败")
                }
                
            } else if package.command == .DAU_write,
                      let rPackage = package as? MGDAUWritePackage {
                if rPackage.params.keys.contains(.wifiList) {
                    
                }
            } else if package.command == .DAU_via {
                
            }
        }
        
    }
}
