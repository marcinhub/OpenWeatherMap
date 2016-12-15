//
//  ViewController.swift
//  Test
//
//  Created by Marcin on 12/12/2016.
//  Copyright © 2016 MarcinSteciuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    var lat : String = ""
    var long : String = ""

    

    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    
    //Refreshing location using "refreshButtonPressed" button
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        locationManager.startUpdatingLocation()
        getWeatherWithLatAndLong(latitude: lat, longitude: long)
        activityIndicator.stopAnimating()


    }
    
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    

    override func viewDidLoad() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        super.viewDidLoad()
        
        //Using locationManager to get current location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if UserDefaults.standard.string(forKey: "description") != nil {
            activityIndicator.startAnimating()
            locationManager.startUpdatingLocation()
            getWeatherWithLatAndLong(latitude: lat, longitude: long)
            activityIndicator.stopAnimating()
        }

    }
    
    //Obtains latitude (lat) and longitude (long)
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        lat = String(format: "%.4f",
                               latestLocation.coordinate.latitude)
        long = String(format: "%.4f",
                                latestLocation.coordinate.longitude)
        if startLocation == nil {
            startLocation = latestLocation
        }

    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
    }
    
    
    //Gets weather JSON using lat and long variables via Alamofire
    func getWeatherWithLatAndLong(latitude: String, longitude: String){
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=2ab2395d40cc7956cc7bb9d13a2b1776").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                print(swiftyJsonVar)
                
                //Parsing JSON using SwiftyJSON
                let desc = swiftyJsonVar["weather"][0]["description"].string
                let temp = swiftyJsonVar["main"]["temp"].double
                let weatherImg = swiftyJsonVar["weather"][0]["icon"].string
                let windSpeed = swiftyJsonVar["wind"]["speed"].int
                let windDeg = swiftyJsonVar["wind"]["deg"].int

                
                //IF JSON data downloaded fine = display the data and save to UserDefaults
                //ELSE data is retrieved from UserDefaults
                //ELSE display message: "No previous data available"
                
                if let description = desc {
                        self.currentConditionLabel.text = "Current Condition: \(description)"
                        UserDefaults.standard.set(description, forKey: "description")
                } else {
                    if let defaultDescription = UserDefaults.standard.string(forKey: "description"){
                        self.currentConditionLabel.text = "Current Condition: \(defaultDescription)"
                    } else {
                        self.currentConditionLabel.text = "No previous data available"
                    }
                }
                
                if let temperature = temp {
                        self.temperatureLabel.text = "Temperature: \(self.tempToCelsius(TempF: temperature)) c"
                        UserDefaults.standard.set(temperature, forKey: "temperature")
                } else {
                        self.temperatureLabel.text = "Temperature: \(self.tempToCelsius(TempF: UserDefaults.standard.double(forKey: "temperature"))) c"
                }
                
                if let windS = windSpeed {
                        self.windSpeedLabel.text = "Wind Speed: \(windS) mph"
                        UserDefaults.standard.set(windS, forKey: "windS")
                } else {
                        self.windSpeedLabel.text = "Wind Speed: \(UserDefaults.standard.integer(forKey: "windS")) mph"
                }
                
                if let windD = windDeg {
                        self.windDirectionLabel.text = "Wind Direction: \(self.convertDegreesNorthToCardinalDirection(degrees: windD))"
                        UserDefaults.standard.set(windD, forKey: "windD")
                } else {
                        self.windDirectionLabel.text = "Wind Direction: \(self.convertDegreesNorthToCardinalDirection(degrees: UserDefaults.standard.integer(forKey: "windD")))"
                }
                
                if let weatherImage = weatherImg {
                    let urlString = "http://openweathermap.org/img/w/\(weatherImage).png"
                    let url = URL(string: urlString)
                    let data = try? Data(contentsOf: url!)
                    self.weatherImage.image = UIImage(data: data!)
                    UserDefaults.standard.set(weatherImage, forKey: "weatherImage")
                } else {
                    if let defaultImageURL = UserDefaults.standard.string(forKey: "weatherImage"){
                        let urlString = "http://openweathermap.org/img/w/\(defaultImageURL).png"
                        let url = URL(string: urlString)
                        let data = try? Data(contentsOf: url!)
                        self.weatherImage.image = UIImage(data: data!)
                            } else{
                            self.weatherImage.image = nil
                            }

                        }

                }
        }
    }
    
    // Helper functions:

    func convertDegreesNorthToCardinalDirection(degrees: Int) -> String {
        
        let cardinals: [String] = [ "North",
                                    "Northeast",
                                    "East",
                                    "Southeast",
                                    "South",
                                    "Southwest",
                                    "West",
                                    "Northwest",
                                    "North" ]
        
        let index = Int(round(Double(degrees).truncatingRemainder(dividingBy: 360) / 45))
        
        return cardinals[index]
        
    }
    
    func tempToCelsius (TempF: Double) -> Int{
     
        let newTemp = Int(TempF - 273.15)
        return newTemp
    }
    


 }




