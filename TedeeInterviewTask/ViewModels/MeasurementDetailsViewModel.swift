//
//  MeasurementDetailsViewModel.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 27/02/2022.
//

import Foundation

class MeasurementDetailsViewModel {
    let bloodPressureValue: Observable<String>
    let measurementTime: Observable<String>
    
    init(measurement: PressureMeasurement) {
        bloodPressureValue = Observable(measurement.value ?? "-/-")
        
        var time = "-"
        if let measureTime = measurement.measureTime {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            time = df.string(from: measureTime)
        }
        measurementTime = Observable(time)
    }
}
