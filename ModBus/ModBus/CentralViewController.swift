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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btleManager.cleanup()
    }

    // MARK: - Helper Methods
    @IBAction func sendCmd(_ sender: Any) {
        let wifiCmd = MGModbusPackage.inquiryDeviceWifiCommand().asData
        btleManager.writeData(with: wifiCmd)
    }
    
    @IBAction func setPwd(_ sender: Any) {
        let wifiCmd = MGModbusPackage.setWifiPwdCommand().asData
        btleManager.writeData(with: wifiCmd)
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
