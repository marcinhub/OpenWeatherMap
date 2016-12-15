//
//  TestService.swift
//  Test
//
//  Created by Marcin on 12/12/2016.
//  Copyright © 2016 MarcinSteciuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation


struct Network {
    
    let latitude: String
    let longitude: String

    
    
      //  typealias weatherArrayCompletion = ([Weather]) -> Void
    func getWeatherWithLatAndLong(latitude: String, longitude: String){
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=2ab2395d40cc7956cc7bb9d13a2b1776").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
            }
        }
    }
}


