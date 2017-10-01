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
    
    
    let locManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //191, 251, 215 day
    // 15 / 12 / 47
    }
    func updateUI() {
        if DataService.ds.temp != "" {
            let farenheitVal = round(Double(DataService.ds.temp)!)
            let celciusVal = round((farenheitVal - 32) * 5 / 9)
            let downloadedImg = DataService.ds.weatherIcon
            DispatchQueue.main.async {
                self.fahrenheitLbl.text = "\(farenheitVal)°F"
                self.celciusLbl.text = "\(celciusVal)°C"
                self.forcastImg.image = UIImage(named: downloadedImg)
                
                if downloadedImg.lowercased().characters.contains("n") {
                    self.view.backgroundColor = UIColor(red: 15/255, green: 12/255, blue: 47/255, alpha: 1.0)
                    self.cityLbl.textColor = UIColor.white
                    self.fahrenheitLbl.textColor = UIColor.white
                    self.celciusLbl.textColor = UIColor.white
                    
                } else {
                    self.view.backgroundColor = UIColor(red: 191/255, green: 251/255, blue: 215/255, alpha: 1.0)
                    self.cityLbl.textColor = UIColor.black
                    self.fahrenheitLbl.textColor = UIColor.black
                    self.celciusLbl.textColor = UIColor.black
                    
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector (updateUI), name: Notification.Name(rawValue: "Temp Changed"), object: nil)
        
        getLocation()
        
        let parsedCity = cityLbl.text?.replacingOccurrences(of: " ", with: "_")
        DataService.ds.getWeather(city: parsedCity!, completion: {
            
        })
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func getLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            self.locManager.requestWhenInUseAuthorization()
            self.locManager.startUpdatingLocation()
            print(CLLocationManager.authorizationStatus().rawValue)
        } else if CLLocationManager.authorizationStatus() == .restricted {
            let alert = UIAlertController(title: "Location Not Authorized", message: "Please turn on location services in the settings", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alert.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        let geoCoder = CLGeocoder()
        
        if let location = locManager.location {
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    for mark in placemarks {
                        print(mark.locality!)
                        self.cityLbl.text = mark.locality
                    }
                }
            }
        }
    }
}
