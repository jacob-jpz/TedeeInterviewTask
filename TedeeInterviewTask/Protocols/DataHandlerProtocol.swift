//
//  DataHandlerProtocol.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation

protocol DataHandlerProtocol {
    func loadSavedMeasurements(_ completion: @escaping ([PressureMeasurement]) -> Void)
    func saveNewMeasurement(value: String, measureTime: Date) -> PressureMeasurement?
    func removeMeasurement(measurement: PressureMeasurement)
    func clearMeasurements(_ measurements: [PressureMeasurement])
}
