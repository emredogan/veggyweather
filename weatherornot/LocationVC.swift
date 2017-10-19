//
//  LocationVC.swift
//  weatherornot
//
//  Created by Emre Dogan on 19/10/2017.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlacesSearchController


class LocationVC: UIViewController  {
    
    let GoogleMapsAPIServerKey = "AIzaSyB4lBU3uJwmSBp5IvJo5Fs57-2BgKnTNrE"
    
    @IBAction func searchAddress(_ sender: UIBarButtonItem) {
        
        
        
        let controller = GooglePlacesSearchController(
            apiKey: GoogleMapsAPIServerKey,
            placeType: PlaceType.cities
        )
        
        //        Or if you want to use autocompletion for specific coordinate and radius (in meters)
        //        let coord = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        //        let controller = GooglePlacesSearchController(
        //            apiKey: GoogleMapsAPIServerKey,
        //            placeType: PlaceType.Address,
        //            coordinate: coord,
        //            radius: 10
        //        )
        
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            //Dismiss Search
            controller.isActive = false
        }
        
        present(controller, animated: true, completion: nil)
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let controller = GooglePlacesSearchController(
            apiKey: GoogleMapsAPIServerKey,
            placeType: PlaceType.cities
        )
        
        //        Or if you want to use autocompletion for specific coordinate and radius (in meters)
        //        let coord = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        //        let controller = GooglePlacesSearchController(
        //            apiKey: GoogleMapsAPIServerKey,
        //            placeType: PlaceType.Address,
        //            coordinate: coord,
        //            radius: 10
        //        )
        
        controller.didSelectGooglePlace { (place) -> Void in
            
            
            
          
            
            CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(place.coordinate.latitude)&lon=\(place.coordinate.longitude)&appid=ce6a7d2f658ebdbd775c6e15cbb16552"
            
            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(place.coordinate.latitude)&lon=\(place.coordinate.longitude)&cnt=10&appid=ce6a7d2f658ebdbd775c6e15cbb16552"
            
            CITY_NAME = place.name
            
            
            
        
            
            
            print(place.description)
            print("dogan\(place.coordinate.latitude)")
            print("dogan\(place.coordinate.longitude)")
            print("dogan name\(place.name)")
           
            
            //Dismiss Search
            controller.isActive = false
            
            self.dismiss(animated: true, completion: nil)

        }
        
        present(controller, animated: true, completion: nil)

    }
    
    
}
