//
//  CitySelectVC.swift
//  Weather Forever
//
//  Created by Patrick Moening on 10/21/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import UIKit

class CitySelectVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var getWeatherBtn: UIButton!
    let backToWeather = "backToWeather"
    var citiesInOrder : Array = [""]
    var cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let whack = UITapGestureRecognizer(target: self, action: #selector(CitySelectVC.dismissKeyboard))
        view.addGestureRecognizer(whack)
    }

    
    func dismissKeyboard(){
        view.endEditing(true)
        cityTextField.text = ""
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherView = segue.destination as? ViewController {
            
            //TODO: Make city label appear when selecting a manual city.
            //TODO: Hide or change the retry button.
            
            weatherView.updateUI()
            
        }
    }
    
    
    //MARK: Buttons
    
    @IBAction func EndTextField(_ sender: Any) {
        
        
        if cityTextField.text != "" {
            cities?.append(cityTextField.text)
            UserDefaults.standard.set(cities, forKey: DataService.ds.cityKey)
            dismissKeyboard()
        }
    
        
        
        performSegue(withIdentifier: backToWeather, sender: self)
        //cityPicker.reloadAllComponents()
    }
    

    @IBAction func checkWeather(_ sender: UIButton) {
        //let selectedCity = citiesInOrder[cityPicker.selectedRow(inComponent: 0)]
        //let parsedCity = selectedCity.replacingOccurrences(of: " ", with: "")
        
        
        performSegue(withIdentifier: backToWeather, sender: self)
        
    }
    
    @IBAction func resetCities(_ sender: UIButton) {
        
        DataService.ds.resetCities()
        tableView.reloadData()
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


//MARK: TableView

extension CitySelectVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: backToWeather, sender: self)
        if let cities = cities {
            DataService.ds.selectedCity = cities[indexPath.row] as! String
        }
        
        
    }
}

extension CitySelectVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cities =  cities {
            return cities.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
        
        if let cities = cities {
            cell.cityLbl.text = cities[indexPath.row] as! String
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    
    
}
//MARK: Picker View
//TODO: Replace picker view with a table view
//I really don't like the whole picker view style and I want to replace it with a table view.
//extension CitySelectVC : UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        if let cityName = UserDefaults.standard.array(forKey: DataService.ds.cityKey) {
//            let reversed = cityName.reversed()
//            let orderedCities = Array(reversed)
//            citiesInOrder = orderedCities as! Array
//            return "\(orderedCities[row])"
//        } else {
//            return "you broke it!"
//        }
//    }
//}
//
//extension CitySelectVC : UIPickerViewDataSource {
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//        let cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
//        if let cities = cities {
//            return cities.count
//        }
//        else {
//            return 1
//        }
//
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
}

