//
//  Utils.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 12/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

func UtilsRandom(withRandom random: Int, between min: Float, and max: Float) -> Float {
    let diff = max - min
    return min + (Float(random / 1000) % diff)
}


class RequestData {
    
    //POST
    func postData(dictionaryData:[String: AnyObject], url:NSString, completion: (result: String) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var data = NSData()
        do{
            data = try NSJSONSerialization.dataWithJSONObject(dictionaryData, options: [])
        }catch let error as NSError {
            print(error)
        }
        
        request.HTTPBody = data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if let actuelError = error{
                print(actuelError)
            }else{
                if let httpResponse = response as? NSHTTPURLResponse {
                    if let dataResponse = httpResponse.allHeaderFields["Data"] as? String {
                        completion(result: dataResponse)
                    }
                }
            }
        }
    }
    
    
    //GET
    func getData(url:NSString)->AnyObject{
        let data = NSData(contentsOfURL: NSURL(string: url as String)!)
        var getResponse:AnyObject = []
        
        if (data != nil){
            do {
                getResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            } catch let error as NSError {
                print(error)
            }
        }else{
            print("error connection database (php)")
        }
        return getResponse
    }
    
}


//GET JSON SYMBIOSIS
class SymbiosisJsonSingleton {
    
    var result = [String : AnyObject]()
    
    func loadJson(firstArray: String, secondArray: String) -> [String : AnyObject] {
        let filePath = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("symbiosis", withExtension:"json")!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(filePath!, options: .AllowFragments)
            
            
            if let allOnboardings = json[firstArray] as? Array<AnyObject> {
                
                for selectedOnboardings in allOnboardings{
                    
                    if let onboarding = selectedOnboardings[secondArray] as? Array<AnyObject>  {
                        
                        for (index, value) in onboarding.enumerate() {
                            
                            if let names = value["name"] as? String {
                                self.result[String(index)] = names
                            }
                        }
                    }
                }
            }
            
        } catch {
            print("error serializing JSON: \(error)")
        }
        return result
    }
    
}

