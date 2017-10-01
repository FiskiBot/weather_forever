//
//  DataService.swift
//  Weather Forever
//
//  Created by Patrick Moening on 9/23/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import Foundation

class DataService : NSObject {
    typealias DownloadCompete = () -> ()
    let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?q="
    let IMPERIAL_UNITS = "units=imperial"
    let API_KEY = "APPID=1636b7bc68a4e607f7531309c857e09b"
    
    var weatherIcon = ""
    var temp = ""
    static var ds = DataService()
    
    func getWeather(city: String, completion: DownloadCompete){
        let tempChanged = Notification(name: Notification.Name(rawValue: "Temp Changed"), object: nil, userInfo: nil)
        if let URL = URL(string: "\(URL_BASE)\(city)&\(IMPERIAL_UNITS)&\(API_KEY)"){
            debugPrint(URL)
            URLSession(configuration: .default).dataTask(with: URL, completionHandler: { (data, response, error) in
                if let error = error {
                    print("###ERROR###")
                    print(error.localizedDescription)
                    print("###########")
                } else if let response = response, let data = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
                        if let main = jsonResult!["main"] as? Dictionary<String,AnyObject>{
                            if let getTemp = main["temp"] {
                                self.temp = "\(getTemp)"
                                
                            }
                        }
                        if let weather = jsonResult!["weather"] as? [Dictionary<String,AnyObject>]{
                            if let getWeather = weather[0]["icon"] {
                                self.weatherIcon = "\(getWeather)"
                                NotificationCenter.default.post(tempChanged)
                            }
                        }
                        
                        print(jsonResult)
                        print(response)
                    } catch {
                        print("Json Serialization failed...")
                    }
                }
            }).resume()
        }
    }
}


