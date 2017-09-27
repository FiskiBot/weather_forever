//
//  DataService.swift
//  Weather Forever
//
//  Created by Patrick Moening on 9/23/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import Foundation

class DataService : NSObject {
    let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?q="
    let IMPERIAL_UNITS = "units=imperial"
    let API_KEY = "APPID=1636b7bc68a4e607f7531309c857e09b"
    var weatherIcon = ""
    static var ds = DataService()
    
    func getWeather(city: String){
        if let URL = URL(string: "\(URL_BASE)\(city)&\(IMPERIAL_UNITS)&\(API_KEY)"){
            URLSession(configuration: .default).dataTask(with: URL, completionHandler: { (data, response, error) in
                if let error = error {
                    print("###ERROR###")
                    print(error.localizedDescription)
                    print("###########")
                } else if let response = response, let data = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:AnyObject]]
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


