//
//  SYOnboardingDataLoader.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 30/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

//GET JSON SYMBIOSIS
class SYDataLoader {
    
    var result = [String : AnyObject]()
    
    func loadJson(firstArray: String, secondArray: String, name:String) -> [String : AnyObject] {
        let filePath = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("symbiosis", withExtension:"json")!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(filePath!, options: .AllowFragments)
            
            if let allOnboardings = json[firstArray] as? Array<AnyObject> {
                
                for selectedOnboardings in allOnboardings{
                    
                    if let onboarding = selectedOnboardings[secondArray] as? Array<AnyObject>  {
                        
                        for (index, value) in onboarding.enumerate() {
                            
                            if let names = value[name] as? String {
                                self.result[String(index)] = names
                            }
                        }
                    }
                }
            }
            
        } catch {
            fatalError("error serializing JSON: \(error)")
        }
        return result
    }
}