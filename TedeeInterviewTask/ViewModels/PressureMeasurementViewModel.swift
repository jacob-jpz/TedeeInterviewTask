//
//  PressureMeasurementViewModel.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation

class PressureMeasurementViewModel {
    let btConnectionStatus: Observable<BtConnectionStatus>
    let measurements: Observable<[PressureMeasurement]>
    
    private var btConnectionService: BtConnectionProtocol
    private let dataHandler: DataHandlerProtocol
    
    init(btConnectionService: BtConnectionProtocol, dataHandler: DataHandlerProtocol) {
        btConnectionStatus = Observable(BtConnectionStatus(connectionStatus: .notConnected, deviceName: ""))
        measurements = Observable([])
        
        self.dataHandler = dataHandler
        self.btConnectionService = btConnectionService
        self.btConnectionService.delegate = self
        
        self.dataHandler.loadSavedMeasurements({ [weak self] measurements in
            guard let self = self else { return }
            self.measurements.value = measurements
        })
    }
    
    func searchForBtDevice() {
        if btConnectionStatus.value.connectionStatus != .notConnected { return }
        btConnectionService.searchForBtDevice()
    }
    
    func fetchBloodPressureMeasurement() {
        if btConnectionStatus.value.connectionStatus != .connected { return }
        btConnectionService.readCurrentValue()
    }
    
    private func saveBloodPressureMeasurement(value: String, time: Date) {
        if let newMeasurement = dataHandler.saveNewMeasurement(value: value, measureTime: time) {
            var list = measurements.value
            list.insert(newMeasurement, at: 0)
            measurements.value = list
        }
    }
    
    func removeBloodPressureMeasurement(_ measurement: PressureMeasurement) {
        dataHandler.removeMeasurement(measurement: measurement)
        
        var list = measurements.value
        if let idx = list.firstIndex(of: measurement) {
            list.remove(at: idx)
            measurements.value = list
        }
    }
    
    func clearMeasurements() {
        dataHandler.clearMeasurements(measurements.value)
        measurements.value = []
    }
}

extension PressureMeasurementViewModel: BtConnectionDelegate {
    func bluetoothOff() {
        btConnectionStatus.value = BtConnectionStatus(connectionStatus: .bluetoothOff)
    }
    
    func bluetoothOn() {
        btConnectionStatus.value = BtConnectionStatus(connectionStatus: .notConnected)
    }
    
    func connectingToDevice(deviceName: String) {
        btConnectionStatus.value = BtConnectionStatus(connectionStatus: .connecting, deviceName: deviceName)
    }
    
    func deviceConnected() {
        btConnectionStatus.value = BtConnectionStatus(connectionStatus: .connected)
    }
    
    func deviceDisconnected() {
        btConnectionStatus.value = BtConnectionStatus(connectionStatus: .notConnected)
    }
    
    func measurementReceived(value: String) {
        saveBloodPressureMeasurement(value: value, time: Date())
    }
}
