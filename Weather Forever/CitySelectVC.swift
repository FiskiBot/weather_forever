//
//  CitySelectVC.swift
//  Weather Forever
//
//  Created by Patrick Moening on 10/21/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import UIKit

class CitySelectVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var getWeatherBtn: UIButton!
    let backToWeather = "backToWeather"
    var citiesInOrder : Array = [""]
    var cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
//        let whack = UITapGestureRecognizer(target: self, action: #selector(CitySelectVC.dismissKeyboard))
//        view.addGestureRecognizer(whack)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherView = segue.destination as? ViewController {
            
            print("Back to Main View")
            //TODO: Make city label appear when selecting a manual city.
            //TODO: Hide or change the retry button.
            
            DataService.ds.getWeather(city: DataService.ds.selectedCity, completion: {
               
                DispatchQueue.main.async {
                    weatherView.city = DataService.ds.selectedCity
                    weatherView.updateUI()
                }
            })
        }
    }

    //MARK: Buttons
 
    
    @IBAction func resetCities(_ sender: UIButton) {
        
        
        DataService.ds.resetCities()
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        performSegue(withIdentifier: backToWeather, sender: self)
        
        
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
        print("Selected")
        
        if let cities = cities {
            let selectedCity = cities[indexPath.row] as! String
            let parsedCity = selectedCity.replacingOccurrences(of: " ", with: "+")
            DataService.ds.selectedCity = parsedCity
        }
        performSegue(withIdentifier: backToWeather, sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic") as! UITableViewCell
        
        if let cities = cities {
            cell.textLabel?.text = cities[indexPath.row] as! String
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

extension CitySelectVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        
        cities?.append(cityTextField.text)
        UserDefaults.standard.set(cities, forKey:"cityArray")
        tableView.reloadData()
        if let enteredCity = cityTextField.text {
            DataService.ds.selectedCity = enteredCity
            
        }
        cityTextField.text = ""
        
        performSegue(withIdentifier: backToWeather, sender: self)
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
}
