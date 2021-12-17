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
    @IBOutlet weak var tableView: UITableView!
    
    var discoveredDevice: [MGBTLEDevice] = []
    var btleManager: BluetoothCentralManager = BluetoothCentralManager()

    convenience init() {
        self.init(nibName: "CentralViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kBtCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        btleManager = BluetoothCentralManager(delegate: self)
        
        self.activityIndicatorView.isHidden = true
    }

    // MARK: - Helper Methods

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "kBtCell", for: indexPath)
        let device = discoveredDevice[indexPath.row]
        cell.textLabel?.text = device.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sDevice = self.discoveredDevice[indexPath.row]
        print("Did selected device: \(sDevice)")
        self.btleManager.connectTo(device: sDevice) { device, error in
            if let error = error {
                print("btleManager connectTo device error \(error.message)")
            } else {
                print("btleManager connectTo device successful")
                self.btleManager.discoverServices(for: sDevice, serviceUUIDs: [TransferService.serviceUUID])
            }
        }
    }
}


extension CentralViewController: BluetoothCentralDelegate {
    func centralManager(manager: BluetoothCentralManager, didWriteData data: Data, for peripheral: CBPeripheral, error: Error?) {
        if let string = String(data: data, encoding: .utf8) {
            writeDataTextView.text = writeDataTextView.text + "\n" + string
        }
    }
    
    func centralManager(manager: BluetoothCentralManager, didDisconnectDevice peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(manager: BluetoothCentralManager, didRecievedData data: Data) {
        print("centralManager didRecievedData")
        if let string = String(data: data, encoding: .utf8) {
            textView.text = textView.text + "\n" + string
        }
    }
}
