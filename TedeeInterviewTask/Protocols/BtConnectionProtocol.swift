//
//  BtConnectionProtocol.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation

protocol BtConnectionProtocol {
    var delegate: BtConnectionDelegate? { get set }
    
    func searchForBtDevice()
    func readCurrentValue()
}
