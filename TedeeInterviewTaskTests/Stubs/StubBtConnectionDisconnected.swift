//
//  StubBtConnectionDisconnected.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask

class StubBtConnectionDisconnected: BtConnectionProtocol {
    var delegate: BtConnectionDelegate?
    
    func searchForBtDevice() {
        delegate?.deviceDisconnected()
    }
    
    func readCurrentValue() {
        
    }
}
