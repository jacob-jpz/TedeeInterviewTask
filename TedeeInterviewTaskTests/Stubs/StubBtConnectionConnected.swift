//
//  StubBtConnectionConnected.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask

class StubBtConnectionConnected: BtConnectionProtocol {
    var delegate: BtConnectionDelegate?
    
    func searchForBtDevice() {
        delegate?.deviceConnected()
    }
    
    func readCurrentValue() {
        
    }
}
