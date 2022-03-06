//
//  BtConnectionService.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 27/02/2022.
//

import Foundation
import CoreBluetooth

class BtConnectionService: NSObject, BtConnectionProtocol {
    static let BloodPressureServiceUUID = CBUUID(string: "1810")
    static let BloodPressureMeasurementCharacteristicUUID = CBUUID(string: "2A35")
    
    var delegate: BtConnectionDelegate?
    
    private var centralManager: CBCentralManager!
    private var bloodPressureDevice: CBPeripheral?
    private var bloodPressureMeasurementCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func searchForBtDevice() {
        centralManager.scanForPeripherals(withServices: [BtConnectionService.BloodPressureServiceUUID], options: nil)
    }
    
    func readCurrentValue() {
        if let bloodPressureDevice = bloodPressureDevice, let bloodPressureMeasurementCharacteristic = bloodPressureMeasurementCharacteristic {
            bloodPressureDevice.readValue(for: bloodPressureMeasurementCharacteristic)
        }
    }
    
    private func disconnectDevice() {
        if let bloodPressureDevice = bloodPressureDevice {
            centralManager.cancelPeripheralConnection(bloodPressureDevice)
            self.bloodPressureDevice = nil
            self.bloodPressureMeasurementCharacteristic = nil
            delegate?.deviceDisconnected()
        }
    }
}

extension BtConnectionService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            disconnectDevice()
            delegate?.bluetoothOff()
        case .poweredOn:
            delegate?.bluetoothOn()
        case .resetting:
            delegate?.deviceDisconnected()
        case .unauthorized, .unknown, .unsupported:
            delegate?.bluetoothOff()
        @unknown default:
            delegate?.bluetoothOff()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        central.stopScan()
        
        bloodPressureDevice = peripheral
        bloodPressureDevice!.delegate = self
        
        delegate?.connectingToDevice(deviceName: peripheral.name ?? "")
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        disconnectDevice()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("fail to connect")
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("conn event occur")
    }
}

extension BtConnectionService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error)")
            disconnectDevice()
            return
        }
        
        guard let services = peripheral.services else {
            print("No services found")
            disconnectDevice()
            return
        }
        
        guard let bloodPressureService = services.first(where: { $0.uuid == BtConnectionService.BloodPressureServiceUUID }) else {
            print("No blood pressure service found")
            disconnectDevice()
            return
        }
        
        peripheral.discoverCharacteristics(nil, for: bloodPressureService)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        if invalidatedServices.first(where: { $0.uuid == BtConnectionService.BloodPressureServiceUUID }) == nil {
            disconnectDevice()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error)")
            disconnectDevice()
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("No characteristics found")
            disconnectDevice()
            return
        }
        
        guard let bloodPressureCharacteristic = characteristics.first(where: { $0.uuid == BtConnectionService.BloodPressureMeasurementCharacteristicUUID }) else {
            print("No blood pressure measurement characteristic found")
            disconnectDevice()
            return
        }
        
        delegate?.deviceConnected()
        bloodPressureMeasurementCharacteristic = bloodPressureCharacteristic
        peripheral.setNotifyValue(true, for: bloodPressureCharacteristic)
        peripheral.readValue(for: bloodPressureCharacteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Characteristic value read error: \(error)")
            return
        }
        
        guard let valueData = characteristic.value else {
            return
        }
        
        if let valueStr = String(data: valueData, encoding: .utf8) {
            delegate?.measurementReceived(value: valueStr)
        }
    }
}
