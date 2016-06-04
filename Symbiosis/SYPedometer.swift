//
//  Pedometer.swift
//  gob-swift-eval
//
//  Created by Quentin Tshaimanga on 22/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreMotion


class SYPedometerData {
    var numberOfSteps: Int = 0
    var distance: Int = 0
    var currentCadence: Int = 0
    var floorsAscended: Int = 0
    var floorsDescended: Int = 0
    var startDate: NSDate
    var endDate: NSDate
    
    init (numberOfSteps: Int, distance: Int, currentCadence: Int, floorsAscended: Int, floorsDescended: Int, startDate: NSDate, endDate: NSDate) {
        self.numberOfSteps = numberOfSteps
        self.distance = distance
        self.currentCadence = currentCadence
        self.floorsAscended = floorsAscended
        self.floorsDescended = floorsDescended
        self.startDate = startDate
        self.endDate = endDate;
    }
}

class SYPedometer {
    var socket = SYSocket.sharedInstance
    weak var delegate: SYPedometerDelegate?
    
    let useNatif: Bool
    var natifPedometer: CMPedometer? = nil
    
    init(useNatif: Bool){
        self.useNatif = useNatif
        
        if self.useNatif == false {
            //USE Socket
            //        self.socket.io.on("UPDATE_PEDOMETER") { data, ack in
            //            let step = data[0].integerValue;
            //            self.delegate?.syPedometer(didReveiveData: step);
            //        }
            
            self.socket.io.on("STATE_UPDATED") {data, ack in
                print("STATE_UPDATED")
                let first = data[0] as! NSMutableDictionary
                var dict = [String : Any]()
                for (key, value) in first {
                    dict[key as! String] = value
                }
                let steps = dict["steps"]! as! Double
                self.delegate?.syPedometer(didReveiveData: NSNumber(double: steps))
            }
        }

    }
    
//    func getPedometerData (fromDate: NSDate, toDate: NSDate) -> SYPedometerData {
//        
//        var numberOfSteps = 0;
//        var distance = 0;
//        var currentCadence = 0;
//        var floorsAscended = 0;
//        var floorsDescended = 0;
//        var startDate : NSDate = NSDate();
//        var endDate: NSDate = NSDate();
//        
//        if ( useNatif ) {
//            self.natifPedometer = CMPedometer()
//            
//            if CMPedometer.isStepCountingAvailable() {
//                print("valid pedometer");
//            } else {
//                print("invalid pedometer");
//            }
//            
//            self.natifPedometer!.queryPedometerDataFromDate(NSDate(), toDate: NSDate(), withHandler: { (data, error) -> Void in
//                
//                numberOfSteps = Int(data!.numberOfSteps)
//                distance = Int(data!.distance!)
//                currentCadence = Int(data!.currentCadence!)
//                floorsAscended = Int(data!.floorsAscended!)
//                floorsDescended = Int (data!.floorsDescended!)
//                //onComplete(SYPedometerData())
//            })
//            
//        } else {
//            
//            //TODO AnyObject to NSDATA
//            
//            //Get DATA
//            let data = NSData(contentsOfURL: NSURL(string: "http://127.0.0.1:8080/pedometerData/")!)
//            
//            var jsonResult : AnyObject
//            
//            if (data != nil){
//                
//                do {
//                    jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                    
//                    if let items = jsonResult as? NSArray {
//                        for item in items {
//                            print(item["numberOfSteps"]!!.integerValue);
//                            print(item["distance"]!!.integerValue);
//                            print(item["currentCadence"]!!.integerValue);
//                            print(item["floorsAscended"]!!.integerValue);
//                            print(item["floorsDescended"]!!.integerValue);
//                            
//                            numberOfSteps = item["numberOfSteps"]!!.integerValue
//                            distance = 10
//                            
//                            let time = 2
//                            currentCadence = distance * time
//                            
//                            floorsAscended = 4
//                            floorsDescended = 2
//                            
//                            startDate = fromDate
//                            endDate = toDate
//                            
//                        }
//                    }
//                    
//                } catch let error as NSError {
//                    print(error)
//                }
//            }else{
//                print("error connection database (php)")
//            }
//            //onComplete(SYPedometerData())
//        }
//        
//        return SYPedometerData(numberOfSteps: numberOfSteps, distance: distance, currentCadence: currentCadence, floorsAscended: floorsAscended, floorsDescended: floorsDescended, startDate: startDate, endDate: endDate)
//        
//    }
    
}

// MARK: SYPedometerDelegate
protocol SYPedometerDelegate: class {
    func syPedometer(didReveiveData data:NSNumber)
}

