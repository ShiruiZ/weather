//
//  changeCity.swift
//  weather
//
//  Created by Shirui Zhang on 2019-05-10.
//  Copyright © 2019 Echo&Chiaki. All rights reserved.
//

import UIKit

protocol changeCityDelegate {
    func newCityNameEntered(newCity : String)
}

class changeCityViewController: UIViewController {
    var delegate : changeCityDelegate?
    
    @IBOutlet weak var newCity: UITextField!
    
    @IBAction func search(_ sender: Any) {
        let city = newCity.text!
        delegate?.newCityNameEntered(newCity: city)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
