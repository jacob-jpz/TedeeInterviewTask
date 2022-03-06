//
//  StubBtConnectionMeasurementReceived.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask

class StubBtConnectionMeasurementReceived: BtConnectionProtocol {
    var delegate: BtConnectionDelegate?
    
    private let measurementValue: String
    
    init(value: String) {
        measurementValue = value
    }
    
    func searchForBtDevice() {
        delegate?.deviceConnected()
    }
    
    func readCurrentValue() {
        delegate?.measurementReceived(value: measurementValue)
    }
}
