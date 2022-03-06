//
//  MeasuremetDetailsViewController.swift
//  TedeeInterviewTask
//
//  Created by Jakub Pazik on 27/02/2022.
//

import UIKit

class MeasuremetDetailsViewController: UIViewController {
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var viewModel: MeasurementDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bloodPressureValue.bind({ [weak self] val in
            self?.lblValue.text = val
        })
        viewModel.measurementTime.bind({ [weak self] val in
            self?.lblTime.text = val
        })
    }
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func removeClick(_ sender: Any) {
        performSegue(withIdentifier: "unwindWithDelete", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
