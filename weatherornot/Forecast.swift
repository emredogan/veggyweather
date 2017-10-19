//
//  Forecast.swift
//  weatherornot
//
//  Created by Emre Dogan on 17/10/2017.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil {
            _date = ""
            
        }
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
                    }
        return _lowTemp

    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                
                    let kelvinToCelsius = forTailingZero(temp: Double(round(min - 273.15)))
                    
                    self._lowTemp = "\(kelvinToCelsius)"
                
                    
                }
            if let max = temp["max"] as? Double {
                
                let kelvinToCelsius = forTailingZero(temp: Double(round(max - 273.15)))
                
                
                self._highTemp = "\(kelvinToCelsius)"
                
            }
            
            
                
            
        }
        
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            
            
            let unixConvertedDAte = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
          //  dateFormatter.dateStyle = .long
              dateFormatter.dateFormat = "EE, MMMM d"
           // dateFormatter.timeStyle = .none
            self._date = "\(dateFormatter.string(from: unixConvertedDAte))"
            
            
            
            
        }
        
        
        
    }
    func forTailingZero(temp: Double) -> String{
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    
    
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

