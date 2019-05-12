//
//  ViewController.swift
//  weather
//
//  Created by Shirui Zhang on 2019-05-02.
//  Copyright © 2019 Echo&Chiaki. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, changeCityDelegate {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var changeLocation: UIButton!
    
    let myURL = "http://api.openweathermap.org/data/2.5/weather"
    let myAPI = "b300ec2d2b5e12bbb80cdb633d18916d"
    
    var locationManager = CLLocationManager()
    var weatherData = WeatherDataStructure()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self as? CLLocationManagerDelegate
        // authorization status
        switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted, .denied:
                cityLabel.text = "Please ask your parents for permission."
                break
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestWhenInUseAuthorization()
                break
        }
        
        //check location service
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        } else {
            cityLabel.text = "Unable to locate. Please check the Settings."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[locations.count - 1]
        if loc.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let lat = loc.coordinate.latitude
            let long = loc.coordinate.longitude
            let posn : [String : String] = ["lat": String(lat),
                                            "lon" : String(long),
                                            "appid" : myAPI]
            //print("param = \(posn)")
            getWeather(url: myURL, para: posn)
        }
    }
    
    func getWeather(url: String, para: [String : String]) {
        Alamofire.request(url, method: .get, parameters: para).responseJSON{
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data!")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeather(data: weatherJSON)
            } else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Failed"
            }
        }
    }
    
    
    func updateWeather(data : JSON) {
        if let resultTemp = data["main"]["temp"].double {
            weatherData.maxTemp = Int(data["main"]["temp_max"].doubleValue - 273.15)
            weatherData.minTemp = Int(data["main"]["temp_min"].doubleValue - 273.15)
            weatherData.temp = Int(resultTemp - 273.15)
            weatherData.windSpeed = data["wind"]["speed"].doubleValue
            weatherData.humidity = data["main"]["humidity"].intValue
            weatherData.cityName = data["name"].stringValue
            weatherData.condition = data["weather"][0]["id"].intValue
            weatherData.icon = weatherData.chooseIcon(condition: weatherData.condition)
            
            updateUI()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUI() {
        cityLabel.text = weatherData.cityName
        icon.image = UIImage(named: weatherData.icon)
        temperatureLabel.text = "\(weatherData.temp)℃"
        maxTemp.text = "maxTemp: \(weatherData.maxTemp)℃"
        minTemp.text = "minTemp: \(weatherData.minTemp)℃"
        windSpeed.text = "wind speed: \(weatherData.windSpeed)m/s"
        humidity.text = "humidity: \(weatherData.humidity)%"
    }
    
   
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    func newCityNameEntered(newCity: String) {
        getWeather(url: myURL, para: ["q" : newCity, "appid" : myAPI])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCity" {
            let destinationVC = segue.destination as! changeCityViewController
            destinationVC.delegate = self
        }
    }

}

