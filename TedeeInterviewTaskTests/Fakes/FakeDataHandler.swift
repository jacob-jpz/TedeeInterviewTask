//
//  FakeDataHandler.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import Foundation
@testable import TedeeInterviewTask
import CoreData

class FakeDataHandler: DataHandlerProtocol {
    private var measurements: [PressureMeasurement] = []
    private let context = NSManagedObjectContext(.mainQueue)
    
    func loadSavedMeasurements(_ completion: @escaping ([PressureMeasurement]) -> Void) {
        completion(measurements)
    }
    
    func saveNewMeasurement(value: String, measureTime: Date) -> PressureMeasurement? {
        let measurement = PressureMeasurement(context: context)
        measurement.value = value
        measurement.measureTime = measureTime
        
        measurements.append(measurement)
        return measurement
    }
    
    func removeMeasurement(measurement: PressureMeasurement) {
        if let measurementIdx = measurements.firstIndex(of: measurement) {
            measurements.remove(at: measurementIdx)
        }
    }
    
    func clearMeasurements(_ measurements: [PressureMeasurement]) {
        self.measurements = []
    }
}
