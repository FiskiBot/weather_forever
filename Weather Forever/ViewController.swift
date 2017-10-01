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
    var city = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector (updateUI), name: Notification.Name(rawValue: "Temp Changed"), object: nil)
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
                
            }
        }
    }
}

extension ViewController : CLLocationManagerDelegate {
    //typealias locComplete = () -> ()
    func getLocation() {
        let gotLoc = Notification(name: Notification.Name(rawValue: "Got Loc"), object: nil, userInfo: nil)
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            self.locManager.requestWhenInUseAuthorization()
            self.locManager.startUpdatingLocation()
            print(CLLocationManager.authorizationStatus().rawValue)
        }
        
        let geoCoder = CLGeocoder()
        
        if let location = locManager.location {
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    for mark in placemarks {
                        print(mark.locality!)
                        self.city = mark.locality!
                        self.cityLbl.text = mark.locality
                        DataService.ds.getWeather(city: mark.locality!, completion: {
                        })
                    }
                }
            }
        }
    }
}
