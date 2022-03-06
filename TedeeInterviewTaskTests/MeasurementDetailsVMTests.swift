//
//  MeasurementDetailsVMTests.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import XCTest
import CoreData
@testable import TedeeInterviewTask

class MeasurementDetailsVMTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMeasurementDisplay() {
        //given
        let context = NSManagedObjectContext(.mainQueue)
        let measurementTime = Date()
        let measurementValue = "120/80"
        let measurement = PressureMeasurement(context: context)
        measurement.value = measurementValue
        measurement.measureTime = measurementTime
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var measurementTimeString: String!
        var bloodPressureValue: String!
        
        //when
        let sut = MeasurementDetailsViewModel(measurement: measurement)
        sut.measurementTime.bind({ val in
            measurementTimeString = val
        })
        sut.bloodPressureValue.bind({ val in
            bloodPressureValue = val
        })
        
        //then
        XCTAssertEqual(measurementTimeString, df.string(from: measurementTime))
        XCTAssertEqual(bloodPressureValue, measurementValue)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
