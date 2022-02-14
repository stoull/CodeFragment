//
//  BluetoothCentral.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import Foundation
import CoreBluetooth
import os

protocol MGBTLECentralManagerDelegate {
    func centralManager(manager: MGBTLECentralManager, didDisconnectDevice peripheral: CBPeripheral, error: Error?)
    func centralManager(manager: MGBTLECentralManager, didRecievedData data: Data)
    func centralManager(manager: MGBTLECentralManager, didWriteData data: Data, for peripheral: CBPeripheral, error: Error?)
    
}

enum MGBTLECentralConnectStatus {
    case connected
    case connecting
}

class MGBTLECentralManager: NSObject {
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
    
    var preWriteData: Data = Data()
    var noti_received_data: Data = Data()
    var isCurrentPeripheralsWritingData: Bool = false

    /// 扫描蓝牙设备结果回调
    private var scanPeripheralDiscoveredBlock: ScanPeripheralDiscovered?
    private var peripheralConnectResult: BtleResult?
    
    var delegate: MGBTLECentralManagerDelegate?
    
    convenience init(delegate: MGBTLECentralManagerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    /// 根据service uuid 获取当前连接的设备，无则返回nil
    func currentConnectedPeripheral(service uuid: CBUUID) -> CBPeripheral?{
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [MGTransferService.serviceUUID]))
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
            periph.delegate = self
            self.peripheralConnectResult = resultHandler
            print("Connecting to perhiperal %@", periph.services as Any)
            centralManager.connect(periph, options: nil)
        } else {
            resultHandler?(device, MGError(message: MGError.kCanNotFindBTLEDeviceInfo, code: 0))
        }
    }
    
    func discoverServices(for device: MGBTLEDevice, serviceUUIDs:[CBUUID]) {
        // Search only for services that match our UUID
        if let perih = device.peripheral {
            perih.delegate = self
            perih.discoverServices([MGTransferService.serviceUUID])
        }
    }
    
    // 取消特征订阅
    func cancel(characteristic: CBCharacteristic) {
        // Cancel our subscription to the characteristic
        currentOperatePeripherals?.setNotifyValue(false, for: characteristic)
    }
    
    /// 获取外围设备。先检查是否有已连接的外围设备，否则基于serviceUUID搜索外围设备
    private func retrievePeripheral() {
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [MGTransferService.serviceUUID]))
        
        print("Found connected Peripherals with transfer service: %@", connectedPeripherals)
        
        if let connectedPeripheral = connectedPeripherals.last {
            print("Connecting to peripheral %@", connectedPeripheral)
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
    func cleanup() {
        // Don't do anything if we're not connected
        guard let discoveredPeripheral = currentOperatePeripherals,
            case .connected = discoveredPeripheral.state else { return }
        
        for service in (discoveredPeripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.uuid == MGTransferService.characteristicUUID && characteristic.isNotifying {
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
    func writeData(with data: Data) {
        self.preWriteData = data
        guard let discoveredPeripheral = currentOperatePeripherals,
                let transferCharacteristic = transferCharacteristic
            else { return }
        
        // check to see if number of iterations completed and peripheral can accept more data
        while writeIterationsComplete < defaultIterations && isCurrentPeripheralsWritingData == false {
                    
            let mtu = discoveredPeripheral.maximumWriteValueLength (for: .withResponse)
            var rawPacket = [UInt8]()
            
            let bytesToCopy: size_t = min(mtu, data.count)
            data.copyBytes(to: &rawPacket, count: bytesToCopy)
            let packetData = Data(bytes: &rawPacket, count: bytesToCopy)
            
            print("Writing data: \(packetData.hexEncodedString().uppercased())")
            
            discoveredPeripheral.writeValue(packetData, for: transferCharacteristic, type: .withResponse)
            
            writeIterationsComplete += 1
            
            isCurrentPeripheralsWritingData = true
        }
    }
}

// MARK: - 中心设备的状态，发现及连接功能
extension MGBTLECentralManager: CBCentralManagerDelegate {
    /// 蓝牙状态实时更新
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.status = central.state
        
        switch central.state {
        case .poweredOn:
            print("蓝牙状态-开启状态")
            
//            retrievePeripheral()
            
        case .poweredOff:
            print("蓝牙状态-关闭状态")
            return
        case .resetting:
            print("蓝牙状态-暂时断开")
            return
        case .unauthorized:
            if #available(iOS 13.1, *) {
                switch CBCentralManager.authorization {
                case .denied:
                    print("蓝牙权限-未被授权")
                case .restricted:
                    print("蓝牙权限-限制状态")
                default:
                    print("蓝牙权限-意外状态")
                }
            } else {
                print("蓝牙权限-未被授权")
            }
            return
        case .unknown:
            print("蓝牙状态-未知")
            return
        case .unsupported:
            print("蓝牙状态-设备不支持")
            return
        @unknown default:
            print("蓝牙状态-未知")
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
//                print("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
//                return
//        }
        
        print("Discovered \(String(describing: peripheral.name)) withRSSI: \(RSSI.intValue)")
        
        print("xxxxx \(peripheral.maximumWriteValueLength(for: .withResponse))")
        
        if discoveredPeripherals.contains(peripheral) == false {
            discoveredPeripherals.append(peripheral)
        }
        
        let btleDevice = MGBTLEDevice(peripheral: peripheral, rssi: RSSI.intValue, advertisementData: advertisementData)
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
        print("Failed to connect to %@. %s", peripheral, String(describing: error))
        self.peripheralConnectResult?(self.currentOperateDevice!, MGError(message: error?.localizedDescription, code: 0))
        cleanup()
    }
    
    /**
     连接设备成功，之后可进行服务及特征（services and characteristics）的发现
     - Parameter central: 中心设备管理者
     - Parameter peripheral: 成功连接的设备
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        let maxWrite = peripheral.maximumWriteValueLength (for: .withResponse)
        let maxWriteNo = peripheral.maximumWriteValueLength(for: .withoutResponse)
        
        print("maximumWriteValueLength: \(maxWrite) withoutResponse: \(maxWriteNo)")
        
        // Stop scanning
        centralManager.stopScan()
        print("Scanning stopped")
        
        // set iteration info
        connectionIterationsComplete += 1
        writeIterationsComplete = 0
        
        // Clear the data that we may already have
        preWriteData.removeAll(keepingCapacity: false)
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
//        // Search only for services that match our UUID
        peripheral.discoverServices([MGTransferService.serviceUUID])
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
        print("Perhiperal Disconnected")
        currentOperatePeripherals = nil
        
        // We're disconnected, so start scanning again
        if connectionIterationsComplete < defaultIterations {
//            retrievePeripheral()
        } else {
            print("Connection iterations completed")
        }
        
        self.delegate?.centralManager(manager: self, didDisconnectDevice: peripheral, error: error)
    }

}

// MARK: - 与外围设备的通信功能
extension MGBTLECentralManager: CBPeripheralDelegate {

    /**
     通知外围设备服务失效
     - Parameter peripheral: 外围设备
     - Parameter didModifyServices: 失效的服务
     */
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        for service in invalidatedServices where service.uuid == MGTransferService.serviceUUID {
            print("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([MGTransferService.serviceUUID])
            peripheral.delegate = self
        }
    }

    /**
     发现外围设备服务
     - Parameter peripheral: 外围设备
     - Parameter didModifyServices: 发现的服务
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            print("didDiscoverServices UUID: \(service.uuid)")
//            print("didDiscoverServices UUID: \(service.uuid)")
            peripheral.discoverCharacteristics([MGTransferService.characteristicUUID], for: service)
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
            print("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Again, we loop through the array, just in case and check if it's the right one
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == MGTransferService.characteristicUUID {
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
            print("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let characteristicData = characteristic.value else { return }
        
        if let endByte = Array(characteristicData).last {
            print("最后一个byte: \(endByte)")
            
            // 判断结束标志
            if endByte == 0x88 {
                print("特征数据接收结束")
                noti_received_data.removeAll()
            } else {
//                noti_received_data.append(characteristicData)
            }
        }
        self.delegate?.centralManager(manager: self, didRecievedData: characteristicData)
    }

    /**
     外围设备写入数据结果回调
     - Parameter peripheral: 外围设备
     - Parameter didUpdateNotificationStateFor characteristic: 特征数据
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        isCurrentPeripheralsWritingData = false
        if characteristic.uuid == MGTransferService.characteristicUUID {
            self.delegate?.centralManager(manager: self, didWriteData: self.preWriteData, for: peripheral, error: error)
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
            print("Error changing notification state: %s", error.localizedDescription)
            return
        }
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid == MGTransferService.characteristicUUID else { return }
        
        if characteristic.isNotifying {
            // Notification has started
            print("Notification began on %@", characteristic)
        } else {
            // Notification has stopped, so disconnect from the peripheral
            print("Notification stopped on %@. Disconnecting", characteristic)
            cleanup()
        }
        
    }
    
    /**
     在外围设备准备好发送状态回调
     */
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("Peripheral is ready, send data")
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
