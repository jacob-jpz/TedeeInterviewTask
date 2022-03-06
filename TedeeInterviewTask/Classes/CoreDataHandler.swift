//
//  CoreDataHandler.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 26/02/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler: DataHandlerProtocol {
    private let context: NSManagedObjectContext
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func loadSavedMeasurements(_ completion: @escaping ([PressureMeasurement]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var measurements = [PressureMeasurement]()
            
            let fetchRequest = PressureMeasurement.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "measureTime", ascending: false)]
            
            do {
                let result = try self.context.fetch(fetchRequest)
                measurements = result
            }
            catch {
                print("Fetching measurements error: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(measurements)
            }
        }
    }
    
    func saveNewMeasurement(value: String, measureTime: Date) -> PressureMeasurement? {
        let measurement = PressureMeasurement(context: context)
        measurement.value = value
        measurement.measureTime = measureTime
        
        if saveContext() {
            return measurement
        }
        
        return nil
    }
    
    func removeMeasurement(measurement: PressureMeasurement) {
        context.delete(measurement)
        saveContext()
    }
    
    func clearMeasurements(_ measurements: [PressureMeasurement]) {
        for measurement in measurements {
            context.delete(measurement)
        }
        
        saveContext()
    }
    
    @discardableResult
    private func saveContext() -> Bool {
        do {
            try context.save()
            return true
        }
        catch {
            print("Saving context error: \(error)")
            return false
        }
    }
}
