//
//  Utils.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 12/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit

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



class Background {

    func addGifBackground(view:UIView, gifView:UIWebView, gifSource: String){
        
        let filePath = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource(gifSource, withExtension:"gif")!)
        
        let webViewBG = gifView
        
        
        webViewBG.loadData(filePath!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        view.addSubview(webViewBG)
        
    }
    
    func adddImageBaclground(view:UIView, imageSource: String){
        let background = UIImage(named: imageSource as String)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
}



func CGPointDistanceSquared(from from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y);
}

func CGPointDistance(from from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to));
}

func CGPointLerp(from from: CGPoint, to: CGPoint, progress: CGFloat) -> CGPoint {
    let x = from.x + ((to.x - from.x) * progress)
    let y = from.y + ((to.y - from.y) * progress)
    return CGPoint(x: x, y: y)
}

func GLKMatrix4MakeRotationToAlign(target: GLKVector3, plan: GLKVector3, axisRotation: Float) -> GLKMatrix4 {
    let targetNor = GLKVector3Normalize(target)
    let planNor = GLKVector3Normalize(plan)
    let axis = GLKVector3Normalize(GLKVector3CrossProduct(targetNor, planNor))
    let angle = acos(GLKVector3DotProduct(targetNor, planNor))
    if isnan(angle) {
        return GLKMatrix4MakeRotation(0, 0, 1, 0)
    }
    // print(NSStringFromGLKVector3(targetNor))
    // print("angle : \(angle)")
    var result = GLKMatrix4MakeRotation(-angle, axis.x, axis.y, axis.z)
    result = GLKMatrix4Multiply(GLKMatrix4MakeRotation(axisRotation, target.x, target.y, target.z), result)
    return result
}
