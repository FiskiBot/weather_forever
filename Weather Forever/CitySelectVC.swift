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
       var cities = UserDefaults.standard.array(forKey: DataService.ds.cityKey)
        if cityTextField.text != "" {
            cities?.append(cityTextField.text as Any)
        } 
        
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
