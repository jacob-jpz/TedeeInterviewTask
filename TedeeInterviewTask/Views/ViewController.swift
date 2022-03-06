//
//  ViewController.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 23/02/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblConnectionStatus: UILabel!
    @IBOutlet weak var lblConnectedDevice: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var tableMeasurements: UITableView!
    
    private var viewModel: PressureMeasurementViewModel!
    private var measurements = [PressureMeasurement]()
    private var selectedMeasurement: PressureMeasurement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataHandler = CoreDataHandler()
        let btConnectionService = BtConnectionService()
        viewModel = PressureMeasurementViewModel(btConnectionService: btConnectionService, dataHandler: dataHandler)
        viewModel.btConnectionStatus.bind(btConnectionStatusUpdate(_:))
        viewModel.measurements.bind(measurementsUpdate(_:))
        
        tableMeasurements.delegate = self
        tableMeasurements.dataSource = self
    }

    private func btConnectionStatusUpdate(_ status: BtConnectionStatus) {
        switch status.connectionStatus {
        case .bluetoothOff:
            lblConnectionStatus.text = "Bluetooth is off"
            lblConnectedDevice.text = "Not connected"
        case .notConnected:
            lblConnectionStatus.text = "Not connected"
            lblConnectedDevice.text = "Not connected"
            viewModel.searchForBtDevice()
        case .connecting:
            lblConnectionStatus.text = "Connecting..."
            lblConnectedDevice.text = status.deviceName
        case .connected:
            lblConnectionStatus.text = "Connected"
        }
        
        btnUpdate.isEnabled = status.connectionStatus == .connected
    }
    
    private func measurementsUpdate(_ measurements: [PressureMeasurement]) {
        self.measurements = measurements
        tableMeasurements.reloadData()
    }
    
    @IBAction func updateClick(_ sender: Any) {
        viewModel.fetchBloodPressureMeasurement()
    }
    
    @IBAction func clearListClick(_ sender: Any) {
        viewModel.clearMeasurements()
    }
    
    @IBAction func unwindWithDelete(_ segue: UIStoryboardSegue) {
        guard let selectedMeasurement = selectedMeasurement else {
            return
        }

        self.selectedMeasurement = nil
        viewModel.removeBloodPressureMeasurement(selectedMeasurement)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
           let measurementDetailsVC = navController.viewControllers.first as? MeasuremetDetailsViewController,
           let selectedMeasurement = selectedMeasurement { 
            let measurementDetailsVM = MeasurementDetailsViewModel(measurement: selectedMeasurement)
            measurementDetailsVC.viewModel = measurementDetailsVM
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "measurementCell") as! BloodPressureCell
        cell.lblValue.text = measurements[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeasurement = measurements[indexPath.row]
        performSegue(withIdentifier: "measurementDetails", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
