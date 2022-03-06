//
//  StubBtConnectionOff.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask

class StubBtConnectionOff: BtConnectionProtocol {
    var delegate: BtConnectionDelegate?
    
    func searchForBtDevice() {
        delegate?.bluetoothOff()
    }
    
    func readCurrentValue() {
        
    }
}
