//
//  Location.swift
//  gob-swift-eval
//
//  Created by Etienne De Ladonchamps on 26/02/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreLocation

class SYLocationManager : NSObject, CLLocationManagerDelegate {
    var useNatif: Bool
    var socket = SYSocket.sharedInstance
    var natifLocationManager: CLLocationManager?
    var natifLocationManagerStatus: CLAuthorizationStatus? = nil
    
    var fakeCurrentLocation = CLLocationCoordinate2D(latitude: 48.872473, longitude: 2.387603)
    var fakeCurrentLocationTarget = CLLocationCoordinate2D(latitude: 48.872473, longitude: 2.387603)
    var fakeCurrentLocationFrom = CLLocationCoordinate2D(latitude: 48.872473, longitude: 2.387603)
    var fakeAnimateInterval = NSTimeInterval(Double(1.0/15.0))
    var fakeAnimateFrame: Int = 0
    var fakeAnimateFrameTarget: Int = 0
    
    weak var delegate: SYLocationManagerDelegate?
    weak var timer = NSTimer()
    
    init (useNatif:Bool) {
        self.useNatif = useNatif
        super.init()
    }
    
    func start () {
        if useNatif {
            // Init CLLocationManager
            self.natifLocationManager = CLLocationManager()
            self.natifLocationManager!.delegate = self
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                self.natifLocationManager!.requestAlwaysAuthorization()
            }
        } else {
//            self.socket.io.on("UPDATE_ME_POSITION") {data, ack in
//                let first = data[0] as! NSMutableDictionary
//                var dict = [String : Any]()
//                for (key, value) in first {
//                    dict[key as! String] = value
//                }
//                let lat = dict["lat"] as! Double
//                let lng = dict["lng"] as! Double
//                self.fakeCurrentLocation.latitude = lat
//                self.fakeCurrentLocation.longitude = lng
//                
//                self.fakeLocationUpdate()
//            }
            self.socket.io.on("STATE_UPDATED") {data, ack in
                let first = data[0] as! NSMutableDictionary
                var dict = [String : Any]()
                for (key, value) in first {
                    dict[key as! String] = value
                }
                let geoloc = dict["geoloc"]! as! [String : Double]
                let lat = geoloc["lat"]!
                let lng = geoloc["lng"]!
                
                self.fakeCurrentLocationTarget.latitude = lat
                self.fakeCurrentLocationTarget.longitude = lng
                
                // For contant speed
//                let latDiff = Float(self.fakeCurrentLocationTarget.latitude) - Float(self.fakeCurrentLocation.latitude)
//                let lngDiff = Float(self.fakeCurrentLocationTarget.longitude) - Float(self.fakeCurrentLocation.longitude)
//                let dist = sqrt(abs(latDiff * lngDiff))
//                let duration = dist * 10
                
                let duration: Float = 0.3
                self.fakeCurrentLocationFrom = self.fakeCurrentLocation
                self.fakeAnimateFrameTarget = Int(floor(duration / Float(self.fakeAnimateInterval)))
                self.fakeAnimateFrame = 0
                
                self.timer?.invalidate()
                self.loopFakeLocationUpdate()
            }
            
            self.delegate?.syLocationManagerDidGetAuthorization(self)
        }
    }
    
    func startUpdateLocation () {
        if self.useNatif {
            let status = self.natifLocationManagerStatus
            if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
                self.natifLocationManager!.startUpdatingLocation()
            }
        } else {
            self.startUpdateFakeLocation()
        }
    }
    
    func startUpdateFakeLocation () {
        self.fakeLocationUpdate()
    }
    
    func fakeLocationUpdate () {
        let altitude = 40.0
        let course = 0.0
        let timestamp = NSDate()
        
        let location = CLLocation(coordinate: self.fakeCurrentLocation, altitude: altitude, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, course: course, speed: 0.5, timestamp: timestamp)
        
        self.syLocationUpdate([location])
        
    }
    
    
    func loopFakeLocationUpdate() {
        
        if fakeAnimateFrame >= fakeAnimateFrameTarget {
            fakeCurrentLocation.latitude = fakeCurrentLocationTarget.latitude
            fakeCurrentLocation.longitude = fakeCurrentLocationTarget.longitude
        } else {
            let progress: Float = Float(fakeAnimateFrame) / Float(fakeAnimateFrameTarget)
            
            let latDiff = Float(self.fakeCurrentLocationTarget.latitude) - Float(self.fakeCurrentLocation.latitude)
            let lngDiff = Float(self.fakeCurrentLocationTarget.longitude) - Float(self.fakeCurrentLocation.longitude)
            
            fakeCurrentLocation.latitude = fakeCurrentLocationFrom.latitude + Double(latDiff * progress)
            fakeCurrentLocation.longitude = fakeCurrentLocationFrom.longitude + Double(lngDiff * progress)
            
            self.fakeAnimateFrame += 1
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.fakeAnimateInterval, target: self, selector: #selector(SYLocationManager.loopFakeLocationUpdate), userInfo: nil, repeats: false)
        }
        
        fakeLocationUpdate()
        
    }
    
    
    func syLocationUpdate (locations: [CLLocation]) {
        if let delegate = self.delegate {
            delegate.syLocationManager(self, didUpdateLocations: locations)
        }
    }
    
    // MARK: CLLocationManager Protocol
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        self.natifLocationManagerStatus = status
        self.delegate?.syLocationManagerDidGetAuthorization(self)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.syLocationUpdate(locations)
    }
    
}

// MARK: SYLocationManagerDelegate

protocol SYLocationManagerDelegate: class {
    // On location update
    func syLocationManager(manager: SYLocationManager, didUpdateLocations locations: [CLLocation])
    // On authorized
    func syLocationManagerDidGetAuthorization(manager: SYLocationManager)
}