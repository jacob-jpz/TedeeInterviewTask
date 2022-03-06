//
//  BtConnectionDelegate.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation

protocol BtConnectionDelegate {
    func bluetoothOff()
    func bluetoothOn()
    func connectingToDevice(deviceName: String)
    func deviceConnected()
    func deviceDisconnected()
    func measurementReceived(value: String)
}
