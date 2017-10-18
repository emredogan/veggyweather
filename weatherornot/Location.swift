//
//  Location.swift
//  weatherornot
//
//  Created by Emre Dogan on 17/10/2017.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    

}


