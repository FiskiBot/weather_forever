//
//  CitySelectVC.swift
//  Weather Forever
//
//  Created by Patrick Moening on 10/21/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import UIKit

class CitySelectVC: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var getWeatherBtn: UIButton!
    let backToWeather = "backToWeather"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let whack = UITapGestureRecognizer(target: self, action: #selector(CitySelectVC.dismissKeyboard))
        view.addGestureRecognizer(whack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
        cityTextField.text = ""
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherView = segue.destination as? ViewController {
            
            //TODO: Make city label appear when selecting a manual city.
            //TODO: Hide or change the retry button.
            weatherView.city = UserDefaults.standard.array(forKey: DataService.ds.cityKey)![cityPicker.selectedRow(inComponent: 0)] as! String
            weatherView.updateUI()
        }
    }
    
    
    //MARK: Buttons
    @IBAction func addCityPressed(_ sender: UIButton) {
        var cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
        
        if cityTextField.text != "" {
            cities?.append(cityTextField.text)
            UserDefaults.standard.set(cities, forKey: DataService.ds.cityKey)
            dismissKeyboard()
        }
        
        cityPicker.reloadAllComponents()
    
    }
   
    @IBAction func checkWeather(_ sender: UIButton) {
        let city = UserDefaults.standard.array(forKey: DataService.ds.cityKey)![cityPicker.selectedRow(inComponent: 0)] as! String
        let parsedCity = city.replacingOccurrences(of: " ", with: "")
        DataService.ds.getWeather(city: parsedCity) {
            
        }
        
        performSegue(withIdentifier: backToWeather, sender: self)
        
    }
    
    @IBAction func resetCities(_ sender: UIButton) {
        
        DataService.ds.resetCities()
        cityPicker.reloadAllComponents()
        dismissKeyboard()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CitySelectVC : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let cityName = UserDefaults.standard.array(forKey: DataService.ds.cityKey) {
            return "\(cityName[row])"
        } else {
            return "you broke it!"
        }
    }
}

extension CitySelectVC : UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
        if let cities = cities {
            return cities.count
        }
        else {
            return 1
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
