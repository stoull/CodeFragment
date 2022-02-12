//
//  ViewController.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import UIKit
import CoreBluetooth
import os

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
    
    let deviceSerialNumber: String = "D0BSB19003"

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
        let dataArray: [UInt8] = [1,13,1,5,0,35,1,19,9,9,9,9,9,9,9,9,9,9,0,4,0,0,19,0,1,6,0,18,0,1,7,0,17,0,1,8,0,16,0,1,9]
        let data = Data(dataArray)
        do {
            let readPackage = try MGDAUReadPackage(responseData: data)
            let rData = readPackage.asData
            print("测试0x19参数读取操作: ")
            var index = 1
            for (key,value) in readPackage.params {
                print("参数 \(index): \(key.name) 编号: \(key.number)")
                if let v = value {
                    print("字节长度：\(v.count), 值：\(v.uint8)")
                }
                index += 1
            }
        } catch let error {
            print("测试0x19参数读取操作错误: \(error)")
        }
        
        
        /// 测试-0x18参数设置操作
        let dataArray_18: [UInt8] = [1,13,1,5,0,15,1,19,9,9,9,9,9,9,9,9,9,9,0,2,0]
        let data_18 = Data(dataArray_18)
        do {
            let readPackage = try MGDAUWritePackage(responseData: data_18)
            let rData = readPackage.asData
            if readPackage.code == .successs {
                print("测试0x18参数设置操作 成功")
            } else {
                print("测试0x18参数设置操作 失败")
            }
        } catch let error {
            print("测试0x18参数设置操作 失败 \(error)")
        }
        
        print("测试-0x17参数设置操作")
        /// 测试-0x17参数设置操作
        /// 01 03 00 17 00 05 75 CC
        let dataArray_17: [UInt8] = [1,3,00,23,0,5,117] // CRC: 75CC
        let rutPackage = MGPenetrateModPackage(slaveAddress: 1, registerTypeOrFunction: .read_holding, startAddress: UInt16(23), count: UInt16(5), setData: [UInt16(117)])
        let pdata = rutPackage.asData()
        for i in 0...pdata.count-1 {
            print(String(format:"%02X", pdata[i]))
        }
        print("package CRC: \(rutPackage.CRC)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btleManager.cleanup()
    }

    // MARK: - Helper Methods
    @IBAction func sendCmd(_ sender: Any) {
        /// 测试-查询wifi信息
        let wifiCmd = MGDAUReadPackage(dauSerial: deviceSerialNumber, parameters: [.wifiList]).asData
        
        print("wifiCmd Data: \(wifiCmd.bytes)")
//        btleManager.writeData(with: wifiCmd)
    }

    @IBAction func setPwd(_ sender: Any) {
        let wifiName = "Growatt88888".data(using: .utf8)!
        let wifiPwd = "wifipassword".data(using: .utf8)!
        let setWifiCmd = MGDAUWritePackage(dauSerial: deviceSerialNumber, parameters: [.wifi_SSID: wifiName, .wifi_password: wifiPwd]).asData
        
        /// 测试-设置wifi信息参数
        print("set wifiCmd Data: \(setWifiCmd.bytes)")
        
//        btleManager.writeData(with: setWifiCmd)
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
    func centralManager(manager: MGBTLECentralManager, didWriteData data: Data, for peripheral: CBPeripheral, error: Error?) {
        print("写入数据成功: \(data.hexEncodedString())")
        writeDataTextView.text = writeDataTextView.text + "\n" +  data.hexEncodedString()
    }
    
    func centralManager(manager: MGBTLECentralManager, didDisconnectDevice peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(manager: MGBTLECentralManager, didRecievedData data: Data) {
        print("特征数据接收:")
//        let modCmd = MGModbusCommand(with: data)
        
        print("Recieved 特征数据: \(data.hexEncodedString())")
        
        textView.text = textView.text + "\n" + data.hexEncodedString()
        
    }
}
