//
//  ViewController.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Variables
    lazy var storage = ApodCache.shared
    var apodViewController: ApodViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Internal Methods
    ///Triggers the APOD search for the selected Date
    @IBAction func handleValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let currentDate = dateFormatter.string(from: sender.date)
        print("Current Date is \(currentDate)")
        self.updateApodInfo(forDateString: currentDate)
    }
    
    ///Navigates to list  all the favourites APODs in new screen
    @IBAction func showFavouriteList(_ sender: UIBarButtonItem) {
        if let favouriteListController = UIStoryboard(name: String(describing: FavouriteListController.self), bundle: nil).instantiateViewController(withIdentifier: String(describing: FavouriteListController.self)) as? FavouriteListController {
            navigationController?.pushViewController(favouriteListController, animated: true)
        }
    }
    
    ///Checks for Cached response is available and returns.
    ///If not, then actual data task query is performed & persisted
    func updateApodInfo(forDateString dateString: String) {
        if let downloadSession = self.apodViewController?.downloadSession {
            self.apodViewController?.downloadSession = downloadSession
            if let apodInfo = storage.getLastResponse(forDateString: dateString) {
                self.apodViewController?.apodInfo = apodInfo
            } else {
                
                self.apodViewController?.queryService.getApodInfo(forDate: dateString) {[weak self] result in
                    switch result {
                    case .success(let apodInfo):
                        self?.apodViewController?.apodInfo = apodInfo
                        self?.storage.saveResponse(apodInfo: apodInfo, forDateString: dateString)
                    case .failure(let error):
                        print("Error is \(error)")
                    }
                }
            }
        }
    }
    
    ///Returns the date formatter
    func getDateformatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
    
    //MARK: - Segue Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let apodVC = segue.destination as? ApodViewController {
            self.apodViewController = apodVC
            let currentDate = getDateformatter().string(from: Date())
            self.updateApodInfo(forDateString: currentDate)
        }
    }
}

