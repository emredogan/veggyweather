//
//  Constants.swift
//  weatherornot
//
//  Created by Emre Dogan on 16/10/2017.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import Foundation

let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"

let LATITUDE = "lat="

let LONGTIDE = "&lon="

let APP_ID = "&appid="

let API_KEY = "ce6a7d2f658ebdbd775c6e15cbb16552"

var CITY_NAME = ""


//let UNITS = "&units=metric"

var CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=ce6a7d2f658ebdbd775c6e15cbb16552"

var FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&appid=ce6a7d2f658ebdbd775c6e15cbb16552"

typealias DownloadComplete = () -> ()




//Currenthttp://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=ce6a7d2f658ebdbd775c6e15cbb16552

//Forecasthttp://samples.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&appid=b1b15e88fa797225412429c1c50c122a1
