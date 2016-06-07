//
//  Seed.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 07/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreLocation

struct Seed {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let date: NSDate
    let id: Int
    
    var isRecent: Bool {
        get {
            let dateNow = NSDate()
            // Add 7 days
            let dateAndAWeek = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 7,
                toDate: self.date,
                options: NSCalendarOptions(rawValue: 0))!
            // Compare
            let compareDateResult = dateAndAWeek.compare(dateNow)
            if compareDateResult == NSComparisonResult.OrderedDescending {
                return false
            }
            return true
        }
    }
}