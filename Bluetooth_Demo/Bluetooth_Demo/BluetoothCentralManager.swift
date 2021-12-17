//
//  BluetoothCentral.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import Foundation
import CoreBluetooth
import os

protocol BluetoothCentralDelegate {
    func centralManager(manager: BluetoothCentralManager, didDisconnectDevice peripheral: CBPeripheral, error: Error?)
    func centralManager(manager: BluetoothCentralManager, didRecievedData data: Data)
    func centralManager(manager: BluetoothCentralManager, didWriteData data: Data, for peripheral: CBPeripheral, error: Error?)
    
}

class BluetoothCentralManager: NSObject {
    typealias ScanPeripheralDiscovered = (MGBTLEDevice?, MGError?)->Void
    typealias BtleResult = (MGBTLEDevice, MGError?)->Void
    
    var centralManager: CBCentralManager!
    /// 当前蓝牙状态
    var status: CBManagerState = .poweredOff
    
    var discoveredPeripherals: [CBPeripheral] = []
    var currentOperatePeripherals: CBPeripheral?
    var transferCharacteristic: CBCharacteristic?
    
    var currentOperateDevice: MGBTLEDevice?

    var writeIterationsComplete = 0
    var connectionIterationsComplete = 0
    
    let defaultIterations = 5     // change this value based on test usecase
    
    var data = Data()
    var isCurrentPeripheralsWritingData: Bool = false

    /// 扫描蓝牙设备结果回调
    private var scanPeripheralDiscoveredBlock: ScanPeripheralDiscovered?
    private var peripheralConnectResult: BtleResult?
    
    var delegate: BluetoothCentralDelegate?
    
    convenience init(delegate: BluetoothCentralDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    /// 根据service uuid 获取当前连接的设备，无则返回nil
    func currentConnectedPeripheral(service uuid: CBUUID) -> CBPeripheral?{
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [TransferService.serviceUUID]))
        if let connectedPeri = connectedPeripherals.last{
            return connectedPeri
        } else {
            return nil
        }
    }
    
    /// 扫描蓝牙设备
    func scanPeripheral(discoverHandler: @escaping ScanPeripheralDiscovered) {
        self.scanPeripheralDiscoveredBlock = discoverHandler
        
        guard self.status == .poweredOn else {
            let error = MGError(message: self.status.localizedName, code: self.status.rawValue)
            discoverHandler(nil, error)
            return
        }
        
        if centralManager.isScanning {
            centralManager.stopScan()
        }
        
        centralManager.scanForPeripherals(withServices: nil,
                                           options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    /// 停止扫描蓝牙设备
    func stopScanPeripheral() {
        if centralManager.isScanning {
            centralManager.stopScan()
        }
    }
    
    // 连接蓝牙设备
    func connectTo(device: MGBTLEDevice, resultHandler: BtleResult?) {
        self.currentOperateDevice = device
        if let periph = device.peripheral {
            self.peripheralConnectResult = resultHandler
            os_log("Connecting to perhiperal %@", periph)
            centralManager.connect(periph, options: nil)
        } else {
            resultHandler?(device, MGError(message: MGError.kCanNotFindBTLEDeviceInfo, code: 0))
        }
    }
    
    func discoverServices(for device: MGBTLEDevice, serviceUUIDs:[CBUUID]) {
        // Search only for services that match our UUID
        if let perih = device.peripheral {
            perih.delegate = self
            perih.discoverServices([TransferService.serviceUUID])
        }
    }
    
    // 取消特征订阅
    func cancel(characteristic: CBCharacteristic) {
        // Cancel our subscription to the characteristic
        currentOperatePeripherals?.setNotifyValue(false, for: characteristic)
    }
    
    /// 获取外围设备。先检查是否有已连接的外围设备，否则基于serviceUUID搜索外围设备
    private func retrievePeripheral() {
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [TransferService.serviceUUID]))
        
        os_log("Found connected Peripherals with transfer service: %@", connectedPeripherals)
        
        if let connectedPeripheral = connectedPeripherals.last {
            os_log("Connecting to peripheral %@", connectedPeripheral)
            self.currentOperatePeripherals = connectedPeripheral
            centralManager.connect(connectedPeripheral, options: nil)
        } else {
            // We were not connected to our counterpart, so start scanning
            centralManager.scanForPeripherals(withServices: nil,
                                               options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    /*
     *  Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    private func cleanup() {
        // Don't do anything if we're not connected
        guard let discoveredPeripheral = currentOperatePeripherals,
            case .connected = discoveredPeripheral.state else { return }
        
        for service in (discoveredPeripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.uuid == TransferService.characteristicUUID && characteristic.isNotifying {
                    // It is notifying, so unsubscribe
                    self.currentOperatePeripherals?.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        // If we've gotten this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    }
    
    /*
     *  Write some test data to peripheral
     */
    private func writeData() {
    
        guard let discoveredPeripheral = currentOperatePeripherals,
                let transferCharacteristic = transferCharacteristic
            else { return }
        
        // check to see if number of iterations completed and peripheral can accept more data
        while writeIterationsComplete < defaultIterations && discoveredPeripheral.canSendWriteWithoutResponse {
                    
            let mtu = discoveredPeripheral.maximumWriteValueLength (for: .withoutResponse)
            var rawPacket = [UInt8]()
            
            let bytesToCopy: size_t = min(mtu, data.count)
            data.copyBytes(to: &rawPacket, count: bytesToCopy)
            let packetData = Data(bytes: &rawPacket, count: bytesToCopy)
            
            let stringFromData = String(data: packetData, encoding: .utf8)
            os_log("Writing %d bytes: %s", bytesToCopy, String(describing: stringFromData))
            
            discoveredPeripheral.writeValue(packetData, for: transferCharacteristic, type: .withResponse)
            
            writeIterationsComplete += 1
            
            isCurrentPeripheralsWritingData = true
        }
        
        if writeIterationsComplete == defaultIterations {
            // Cancel our subscription to the characteristic
            discoveredPeripheral.setNotifyValue(false, for: transferCharacteristic)
        }
    }
}

// MARK: - 中心设备的状态，发现及连接功能
extension BluetoothCentralManager: CBCentralManagerDelegate {
    /// 蓝牙状态实时更新
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.status = central.state
        
        switch central.state {
        case .poweredOn:
            os_log("蓝牙状态-开启状态")
            
//            retrievePeripheral()
            
        case .poweredOff:
            os_log("蓝牙状态-关闭状态")
            return
        case .resetting:
            os_log("蓝牙状态-暂时断开")
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

    /**
     扫描到外围设备
     - Parameter central: 中心设备管理者
     - Parameter peripheral: 扫描到的外围设备
     - Parameter advertisementData: 外围设备的广播数据 设备名key CBAdvertisementDataLocalName
     - Parameter rssi: 信号强度 单位为 dBm，当为127时为不可用
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // 过滤信号弱的设备
//        guard RSSI.intValue >= -50
//            else {
//                os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
//                return
//        }
        
        os_log("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)
        
        if discoveredPeripherals.contains(peripheral) == false {
            discoveredPeripherals.append(peripheral)
        }
        

        let btleDevice = MGBTLEDevice(peripheral: peripheral, advertisementData: advertisementData)
        if btleDevice.name.count > 0 {
            if let discoverdBlock = self.scanPeripheralDiscoveredBlock {
                discoverdBlock(btleDevice, nil)
            }
        }
        
    }

    /**
     连接外围设备失败
     - Parameter central: 中心设备管理者
     - Parameter didFailToConnect: 尝试连接的外围设备
     - Parameter error: 错误信息
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
        self.peripheralConnectResult?(self.currentOperateDevice!, MGError(message: error?.localizedDescription, code: 0))
        cleanup()
    }
    
    /**
     连接设备成功，之后可进行服务及特征（services and characteristics）的发现
     - Parameter central: 中心设备管理者
     - Parameter peripheral: 成功连接的设备
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Peripheral Connected")
        
        // Stop scanning
        centralManager.stopScan()
        os_log("Scanning stopped")
        
        // set iteration info
        connectionIterationsComplete += 1
        writeIterationsComplete = 0
        
        // Clear the data that we may already have
        data.removeAll(keepingCapacity: false)
        
        // Make sure we get the discovery callbacks
//        peripheral.delegate = self
//
//        // Search only for services that match our UUID
//        peripheral.discoverServices([TransferService.serviceUUID])
        self.currentOperatePeripherals = peripheral
        self.peripheralConnectResult?(self.currentOperateDevice!, nil)
    }
    
    /*
     *  Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    
    
    /**
     设备断开连接，可清理设备信息
     - Parameter central: 中心设备管理者
     - Parameter peripheral: 成功断开连接的设备
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        os_log("Perhiperal Disconnected")
        currentOperatePeripherals = nil
        
        // We're disconnected, so start scanning again
        if connectionIterationsComplete < defaultIterations {
//            retrievePeripheral()
        } else {
            os_log("Connection iterations completed")
        }
        
        self.delegate?.centralManager(manager: self, didDisconnectDevice: peripheral, error: error)
    }

}

// MARK: - 与外围设备的通信功能
extension BluetoothCentralManager: CBPeripheralDelegate {

    /**
     通知外围设备服务失效
     - Parameter peripheral: 外围设备
     - Parameter didModifyServices: 失效的服务
     */
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        for service in invalidatedServices where service.uuid == TransferService.serviceUUID {
            os_log("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([TransferService.serviceUUID])
        }
    }

    /**
     发现外围设备服务
     - Parameter peripheral: 外围设备
     - Parameter didModifyServices: 发现的服务
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            os_log("Error discovering services: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics([TransferService.characteristicUUID], for: service)
        }
    }
    
    /**
     发现外围设备特征数据
     - Parameter peripheral: 外围设备
     - Parameter didDiscoverCharacteristicsFor service: 发现的服务
     */
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any).
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Again, we loop through the array, just in case and check if it's the right one
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == TransferService.characteristicUUID {
            // If it is, subscribe to it
            transferCharacteristic = characteristic
            // 订阅特征
            peripheral.setNotifyValue(true, for: characteristic)
        }
        
        // Once this is complete, we just need to wait for the data to come in.
    }

    /**
     外围设备特征数据通过通知更新
     - Parameter peripheral: 外围设备
     - Parameter didUpdateValueFor characteristic: 特征数据
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let characteristicData = characteristic.value,
            let stringFromData = String(data: characteristicData, encoding: .utf8) else { return }
        
        os_log("Received %d bytes: %s", characteristicData.count, stringFromData)
        
        self.delegate?.centralManager(manager: self, didRecievedData: characteristicData)
        
        // Have we received the end-of-message token?
        if stringFromData == "EOM" {
            // End-of-message case: show the data.
            // Dispatch the text view update to the main queue for updating the UI, because
            // we don't know which thread this method will be called back on.
//            DispatchQueue.main.async() {
//                self.textView.text = String(data: self.data, encoding: .utf8)
//            }
            
            // Write test data
            writeData()
        } else {
            // Otherwise, just append the data to what we have previously received.
//            data.append(characteristicData)
            if let backString = "是我写入到你的那边的，我是stoull".data(using: .utf8) {
                data.append(backString)
            }
            
        }
    }

    /**
     外围设备写入数据结果回调
     - Parameter peripheral: 外围设备
     - Parameter didUpdateNotificationStateFor characteristic: 特征数据
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        isCurrentPeripheralsWritingData = false
        if characteristic.uuid == TransferService.characteristicUUID {
            self.delegate?.centralManager(manager: self, didWriteData: self.data, for: peripheral, error: error)
        }
    }


    /**
     订阅结果回调
     - Parameter peripheral: 外围设备
     - Parameter didUpdateNotificationStateFor characteristic: 特征数据
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error changing notification state: %s", error.localizedDescription)
            return
        }
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid == TransferService.characteristicUUID else { return }
        
        if characteristic.isNotifying {
            // Notification has started
            os_log("Notification began on %@", characteristic)
        } else {
            // Notification has stopped, so disconnect from the peripheral
            os_log("Notification stopped on %@. Disconnecting", characteristic)
            cleanup()
        }
        
    }
    
    /**
     在外围设备准备好发送状态回调
     */
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        os_log("Peripheral is ready, send data")
        writeData()
    }
    
}


extension CBManagerState {
    var localizedName: String {
        var name: String = "蓝牙状态-开启状态"
        switch self {
        case .unknown:
            name = "蓝牙状态-未知"
        case .resetting:
            name = "蓝牙状态-暂时断开"
        case .unsupported:
            name = "蓝牙状态-设备不支持"
        case .unauthorized:
            name = "蓝牙权限-未被授权"
        case .poweredOff:
            name = "蓝牙状态-关闭状态"
        case .poweredOn:
            name = "蓝牙状态-开启状态"
        @unknown default:
            name = "蓝牙权限-意外状态"
        }
        return name
    }
}
