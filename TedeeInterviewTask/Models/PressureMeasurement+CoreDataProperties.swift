//
//  PressureMeasurement+CoreDataProperties.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 27/02/2022.
//
//

import Foundation
import CoreData


extension PressureMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PressureMeasurement> {
        return NSFetchRequest<PressureMeasurement>(entityName: "PressureMeasurement")
    }

    @NSManaged public var measureTime: Date?
    @NSManaged public var value: String?

}

extension PressureMeasurement : Identifiable {

}
