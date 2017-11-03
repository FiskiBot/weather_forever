//
//  ViewController.swift
//  Weather Forever
//
//  Created by Patrick Moening on 5/23/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var forcastImg: UIImageView!
    @IBOutlet weak var fahrenheitLbl: UILabel!
    @IBOutlet weak var celciusLbl: UILabel!
    @IBOutlet weak var weatherDescriptionLbl: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let locManager = CLLocationManager()
    var city = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector (updateUI), name: Notification.Name(rawValue: "Temp Changed"), object: nil)
    }
    
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        cityLbl.text = city
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func handleError() {
        let locError = UIAlertController(title: "Could Not find your location", message: "Please use this in an area that we can find you and press retry.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        locError.addAction(okButton)
        present(locError, animated: true, completion: nil)
        self.retryButton.isHidden = false
    }
    
    func updateUI() {
        if DataService.ds.temp != "" {
            let farenheitVal = (Double(DataService.ds.temp)!)
            let celciusVal = ((farenheitVal - 32) * 5 / 9)
            let downloadedImg = DataService.ds.weatherIcon
            DispatchQueue.main.async {
                self.fahrenheitLbl.text = String(format: "%.1f", farenheitVal) + "°F"
                self.celciusLbl.text = String(format: "%.1f", celciusVal) + "°C"
                self.forcastImg.image = UIImage(named: downloadedImg)
                self.weatherDescriptionLbl.text = DataService.ds.weatherDescription
                
            }
        }
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        getLocation()
        
    }
    
}

extension ViewController : CLLocationManagerDelegate {
    //typealias locComplete = () -> ()
    func getLocation() {
        let gotLoc = Notification(name: Notification.Name(rawValue: "Got Loc"), object: nil, userInfo: nil)
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            self.locManager.requestWhenInUseAuthorization()
            print(CLLocationManager.authorizationStatus().rawValue)
        }
        self.locManager.startUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        
        if let location = locManager.location {
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    for mark in placemarks {
                        print(mark.locality)
                        self.cityLbl.text = mark.locality
                        if let parsedLoc = mark.locality?.replacingOccurrences(of: " ", with: "_") {
                            DataService.ds.getWeather(city: parsedLoc, completion: {
                                
                            })
                        } else {
                           self.handleError()
                        }
                    }
                } else {
                    self.handleError()
                }
            }
        } else {
            handleError()
        }
    }
}

