//
//  weatherDataStructure.swift
//  weather
//
//  Created by Shirui Zhang on 2019-05-07.
//  Copyright © 2019 Echo&Chiaki. All rights reserved.
//

import Foundation

class WeatherDataStructure {
    var maxTemp : Int = 0
    var minTemp : Int = 0
    var temp : Int = 0
    var windSpeed : Double = 0.0
    var humidity : Int = 0
    var cityName : String = ""
    
    var condition : Int = 0
    var icon : String = ""
    
    func chooseIcon(condition : Int) -> String {
        switch condition {
        case let condition where condition >= 200 && condition < 300:
            return "thunderbolt"
        case let condition where condition >= 300 && condition < 600:
            return "rainy"
        case let condition where condition >= 600 && condition < 700:
            return "snowy"
        case let condition where condition >= 700 && condition < 771:
            return "cloudy"
        case let condition where condition >= 771 && condition <= 781:
            return "tornado"
        case let condition where condition == 800:
            return "sunny"
        case let condition where condition >= 801 && condition <= 804:
            return "suncloud"
        default:
            return "unknown"
        }
    }
    
}
