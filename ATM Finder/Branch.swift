//
//  Branch.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit

class Branch: Location {
    var phoneNumber: NSString?
    var faxNumber: NSString?
    var openingHours: Array<OpeningHours>?
    var shortOpeningHours: NSString?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if (key == "openingHours") {
            let (success, result): (Bool, Array<OpeningHours>) = BaseModelHelper<OpeningHours>.transformToArrayFromValue(value)
            
            if (success) {
                super.setValue(result, forKey: key)
            }
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}
