//
//  Location.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit
import MapKit

class Location: BaseModel, MKAnnotation {
    
    var type: NSString?
    var name: NSString?
    var address: NSString?
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var branchNumber: NSString?
    
    var coordinate: CLLocationCoordinate2D {
        get {
            if (latitude < -360.0 || latitude > 360.0)
            {
                latitude = 0.0
            }
            
            if (longitude < -360.0 || longitude > 360.0)
            {
                longitude = 0.0
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}