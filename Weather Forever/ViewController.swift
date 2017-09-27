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
      getLocation()
    }
    
    @IBAction func testJSon(_ sender: UIButton) {
        DataService.ds.getWeather(city: cityLbl.text!)
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func getLocation() {
        
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
                        self.cityLbl.text = mark.locality
                    }
                }
            }
        }
    }
}
