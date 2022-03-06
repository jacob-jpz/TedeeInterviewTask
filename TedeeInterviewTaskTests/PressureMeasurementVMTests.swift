//
//  PressureMeasurementVMTests.swift
//  TedeeInterviewTaskTests
//
//  Created by Jakub Pazik on 05/03/2022.
//

import XCTest
@testable import TedeeInterviewTask

class PressureMeasurementVMTests: XCTestCase {
    enum TestError: Error {
        case error
    }
    
    var dataHandler: FakeDataHandler!
    var btConnectionService: BtConnectionProtocol!
    var btConnectionStatus: BtConnectionStatus!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataHandler = FakeDataHandler()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataHandler = nil
        btConnectionService = nil
        btConnectionStatus = nil
    }

    func testBluetoothOff() {
        //given
        btConnectionService = StubBtConnectionOff()
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.btConnectionStatus.bind({ status in
            self.btConnectionStatus = status
        })
        
        //when
        sut.searchForBtDevice()
        
        //then
        XCTAssertEqual(btConnectionStatus.connectionStatus, BtConnectionStatus.ConnectionStatus.bluetoothOff)
        XCTAssertEqual(btConnectionStatus.deviceName, "")
    }
    
    func testBluetoothOn() {
        //given
        btConnectionService = StubBtConnectionOn()
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.btConnectionStatus.bind({ status in
            self.btConnectionStatus = status
        })
        
        //when
        sut.searchForBtDevice()
        
        //then
        XCTAssertEqual(btConnectionStatus.connectionStatus, BtConnectionStatus.ConnectionStatus.notConnected)
        XCTAssertEqual(btConnectionStatus.deviceName, "")
    }
    
    func testConnectingToDevice() {
        //given
        let deviceName = "Test bt device"
        btConnectionService = StubBtConnectionConnecting(toDeviceWithName: deviceName)
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.btConnectionStatus.bind({ status in
            self.btConnectionStatus = status
        })
        
        //when
        sut.searchForBtDevice()
        
        //then
        XCTAssertEqual(btConnectionStatus.connectionStatus, BtConnectionStatus.ConnectionStatus.connecting)
        XCTAssertEqual(btConnectionStatus.deviceName, deviceName)
    }
    
    func testConnectedToDevice() {
        //given
        btConnectionService = StubBtConnectionConnected()
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.btConnectionStatus.bind({ status in
            self.btConnectionStatus = status
        })
        
        //when
        sut.searchForBtDevice()
        
        //then
        XCTAssertEqual(btConnectionStatus.connectionStatus, BtConnectionStatus.ConnectionStatus.connected)
        XCTAssertEqual(btConnectionStatus.deviceName, "")
    }
    
    func testDisconnectedDevice() {
        //given
        btConnectionService = StubBtConnectionDisconnected()
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.btConnectionStatus.bind({ status in
            self.btConnectionStatus = status
        })
        
        //when
        sut.searchForBtDevice()
        
        //then
        XCTAssertEqual(btConnectionStatus.connectionStatus, BtConnectionStatus.ConnectionStatus.notConnected)
        XCTAssertEqual(btConnectionStatus.deviceName, "")
    }
    
    func testMeasurementFetched() {
        //given
        let measurementValue = "120/80"
        btConnectionService = StubBtConnectionMeasurementReceived(value: measurementValue)
        var measurementList: [PressureMeasurement]!
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.measurements.bind({ measurements in
            measurementList = measurements
        })
        
        //when
        sut.searchForBtDevice()
        sut.fetchBloodPressureMeasurement()
        
        //then
        XCTAssertEqual(measurementList.count, 1)
        XCTAssertEqual(measurementList.first?.value ?? "", measurementValue)
    }
    
    func testMeasurementDelete() throws {
        //given
        let measurementValue = "120/80"
        btConnectionService = StubBtConnectionMeasurementReceived(value: measurementValue)
        var measurementList: [PressureMeasurement]!
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.measurements.bind({ measurements in
            measurementList = measurements
        })
        
        //when
        sut.searchForBtDevice()
        sut.fetchBloodPressureMeasurement()
        guard let measurement = measurementList.first else {
            throw TestError.error
        }
        sut.removeBloodPressureMeasurement(measurement)
        
        //then
        XCTAssertEqual(measurementList.count, 0)
    }
    
    func testMeasurementsClear() {
        //given
        let measurementValue = "120/80"
        btConnectionService = StubBtConnectionMeasurementReceived(value: measurementValue)
        var measurementList: [PressureMeasurement]!
        let sut = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        sut.measurements.bind({ measurements in
            measurementList = measurements
        })
        
        //when
        sut.searchForBtDevice()
        sut.fetchBloodPressureMeasurement()
        sut.clearMeasurements()
        
        //then
        XCTAssertEqual(measurementList.count, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
