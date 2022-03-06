//
//  StubBtConnectionConnecting.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask

class StubBtConnectionConnecting: BtConnectionProtocol {
    var delegate: BtConnectionDelegate?
    
    private let deviceName: String
    
    init(toDeviceWithName: String) {
        deviceName = toDeviceWithName
    }
    
    func searchForBtDevice() {
        delegate?.connectingToDevice(deviceName: deviceName)
    }
    
    func readCurrentValue() {
        
    }
}
