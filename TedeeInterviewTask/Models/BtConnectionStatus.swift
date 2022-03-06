//
//  BtConnectionStatus.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation

class BtConnectionStatus {
    enum ConnectionStatus {
        case bluetoothOff, notConnected, connecting, connected
    }
    
    let connectionStatus: ConnectionStatus
    let deviceName: String
    
    init(connectionStatus: ConnectionStatus) {
        self.connectionStatus = connectionStatus
        deviceName = ""
    }
    
    init(connectionStatus: ConnectionStatus, deviceName: String) {
        self.connectionStatus = connectionStatus
        self.deviceName = deviceName
    }
}
