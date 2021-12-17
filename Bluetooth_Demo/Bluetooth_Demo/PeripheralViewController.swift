//
//  PeripheralViewController.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import UIKit
import CoreBluetooth
import os

class PeripheralViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    @IBOutlet var advertisingSwitch: UISwitch!
    
    var peripheralManager: CBPeripheralManager!

    var transferCharacteristic: CBMutableCharacteristic?
    var connectedCentral: CBCentral?
    var dataToSend = Data()
    var sendDataIndex: Int = 0
    
    // MARK: - View Lifecycle
    convenience init() {
        self.init(nibName: "PeripheralViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Don't keep advertising going while we're not showing.
        peripheralManager.stopAdvertising()

        super.viewWillDisappear(animated)
    }
    
    // MARK: - Switch Methods

    @IBAction func switchChanged(_ sender: Any) {
        // All we advertise is our service's UUID.
        if advertisingSwitch.isOn {
            peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: "Hut_Hutttt", CBAdvertisementDataServiceUUIDsKey: [TransferService.serviceUUID]])
        } else {
            peripheralManager.stopAdvertising()
        }
    }

    // MARK: - Helper Methods

    /*
     *  Sends the next amount of data to the connected central
     */
    static var sendingEOM = false
    
    private func sendData() {
        
        guard let transferCharacteristic = transferCharacteristic else {
            return
        }
        
        // First up, check if we're meant to be sending an EOM
        if PeripheralViewController.sendingEOM {
            // send it
            let didSend = peripheralManager.updateValue("EOM".data(using: .utf8)!, for: transferCharacteristic, onSubscribedCentrals: nil)
            // Did it send?
            if didSend {
                // It did, so mark it as sent
                PeripheralViewController.sendingEOM = false
                os_log("Sent: EOM")
            }
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        // Is there any left to send?
        if sendDataIndex >= dataToSend.count {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        while didSend {
            
            // Work out how big it should be
            var amountToSend = dataToSend.count - sendDataIndex
            if let mtu = connectedCentral?.maximumUpdateValueLength {
                amountToSend = min(amountToSend, mtu)
            }
            
            // Copy out the data we want
            let chunk = dataToSend.subdata(in: sendDataIndex..<(sendDataIndex + amountToSend))
            
            // Send it
            didSend = peripheralManager.updateValue(chunk, for: transferCharacteristic, onSubscribedCentrals: nil)
            
            // If it didn't work, drop out and wait for the callback
            if !didSend {
                return
            }
            
            let stringFromData = String(data: chunk, encoding: .utf8)
            os_log("Sent %d bytes: %s", chunk.count, String(describing: stringFromData))
            
            // It did send, so update our index
            sendDataIndex += amountToSend
            // Was it the last one?
            if sendDataIndex >= dataToSend.count {
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                PeripheralViewController.sendingEOM = true
                
                //Send it
                let eomSent = peripheralManager.updateValue("EOM".data(using: .utf8)!,
                                                             for: transferCharacteristic, onSubscribedCentrals: nil)
                
                if eomSent {
                    // It sent; we're all done
                    PeripheralViewController.sendingEOM = false
                    os_log("Sent: EOM")
                }
                return
            }
        }
    }

    private func setupPeripheral() {
        
        // Build our service.
        
        // Start with the CBMutableCharacteristic.
        let transferCharacteristic = CBMutableCharacteristic(type: TransferService.characteristicUUID,
                                                         properties: [.notify, .write],
                                                         value: nil,
                                                         permissions: [.readable, .writeable])
        
        // Create a service from the characteristic.
        let transferService = CBMutableService(type: TransferService.serviceUUID, primary: true)
        
        // Add the characteristic to the service.
        transferService.characteristics = [transferCharacteristic]
        
        // And add it to the peripheral manager.
        peripheralManager.add(transferService)
        
        // Save the characteristic for later.
        self.transferCharacteristic = transferCharacteristic

    }
}

extension PeripheralViewController: CBPeripheralManagerDelegate {
    // implementations of the CBPeripheralManagerDelegate methods

    /*
     *  Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for to know when the CBPeripheralManager is ready
     *
     *  Starting from iOS 13.0, if the state is CBManagerStateUnauthorized, you
     *  are also required to check for the authorization state of the peripheral to ensure that
     *  your app is allowed to use bluetooth
     */
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        advertisingSwitch.isEnabled = peripheral.state == .poweredOn
        
        switch peripheral.state {
        case .poweredOn:
            os_log("蓝牙状态-开启状态")
            setupPeripheral()
        case .poweredOff:
            os_log("蓝牙状态-关闭状态")
            return
        case .resetting:
            os_log("CBManager is resetting")
            return
        case .unauthorized:
            if #available(iOS 13.1, *) {
                switch CBCentralManager.authorization {
                case .denied:
                    os_log("蓝牙权限-未被授权")
                case .restricted:
                    os_log("蓝牙权限-限制状态")
                default:
                    os_log("蓝牙权限-意外状态")
                }
            } else {
                os_log("蓝牙权限-未被授权")
            }
            return
        case .unknown:
            os_log("蓝牙状态-未知")
            return
        case .unsupported:
            os_log("蓝牙状态-设备不支持")
            return
        @unknown default:
            os_log("蓝牙状态-未知")
            return
        }
    }

    /*
     *  Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        os_log("Central subscribed to characteristic")
        
        // Get the data
        dataToSend = textView.text.data(using: .utf8)!
        
        // Reset the index
        sendDataIndex = 0
        
        // save central
        connectedCentral = central
        
        // Start sending
        sendData()
    }
    
    /*
     *  Recognize when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic")
        connectedCentral = nil
    }
    
    /*
     *  This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    
    /*
     * This callback comes in when the PeripheralManager received write to characteristics
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for aRequest in requests {
            guard let requestValue = aRequest.value,
                let stringFromData = String(data: requestValue, encoding: .utf8) else {
                    continue
            }
            
            os_log("Received write request of %d bytes: %s", requestValue.count, stringFromData)
            self.textView.text = stringFromData
        }
    }
}

extension PeripheralViewController: UITextViewDelegate {
    // implementations of the UITextViewDelegate methods

    /*
     *  This is called when a change happens, so we know to stop advertising
     */
    func textViewDidChange(_ textView: UITextView) {
        // If we're already advertising, stop
        if advertisingSwitch.isOn {
            advertisingSwitch.isOn = false
            peripheralManager.stopAdvertising()
        }
    }
    
    /*
     *  Adds the 'Done' button to the title bar
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        // We need to add this manually so we have a way to dismiss the keyboard
        let rightButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    /*
     * Finishes the editing
     */
    @objc
    func dismissKeyboard() {
        textView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
}
