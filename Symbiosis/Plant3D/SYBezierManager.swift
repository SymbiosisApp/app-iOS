//
//  SYRandomManager.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 25/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

struct SYBezierOptions {
    let yolo: Int = 0
}
func ==(lhs: SYBezierOptions, rhs: SYBezierOptions) -> Bool {
    let isEqual = (lhs.yolo == rhs.yolo)
    return isEqual
}

struct SYBezier {
    let name: String
    let path: SYPath
    let options: SYBezierOptions
    
    func valueAtTime(time: Float) -> CGPoint {
        return path.valueAtTime(time)
    }
}

class SYBezierManager {
    
    var beziers: [SYBezier] = []
    
    func get(key: String, options: SYBezierOptions?) -> SYBezier {
        var opt: SYBezierOptions
        if options == nil {
            opt = SYBezierOptions()
        } else {
            opt = options!
        }
        var bezier = self.findBezier(key, options: opt)
        if bezier == nil {
            bezier = generateBezier(key, options: opt)
            self.beziers.append(bezier!)
        }
        return bezier!
    }
    
    func findBezier(key: String, options: SYBezierOptions) -> SYBezier? {
        for bezier in self.beziers {
            let finded = bezier.name == key && options == options
            if finded {
                return bezier
            }
        }
        return nil
        
    }
    
    func generateBezier(key: String, options: SYBezierOptions) -> SYBezier {
        let path = UIBezierPath()
        switch key {
        
        case "trunk":
            path.moveToPoint(CGPoint(x: 0.3, y: 0.2))
            path.addCurveToPoint(CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0.3, y: 0.1), controlPoint2: CGPoint(x: 0.2, y: 0))
            path.addCurveToPoint(CGPoint(x: -0.2, y: 0.2), controlPoint1: CGPoint(x: -0.15, y: 0), controlPoint2: CGPoint(x: -0.2, y: 0.1))
            path.addCurveToPoint(CGPoint(x: 0.2, y: 0.8), controlPoint1: CGPoint(x: -0.2, y: 0.5), controlPoint2: CGPoint(x: 0.2, y: 0.6))
            path.addCurveToPoint(CGPoint(x: 0, y: 1), controlPoint1: CGPoint(x: 0.2, y: 0.9), controlPoint2: CGPoint(x: 0.1, y: 1))
            
        case "trunk-width":
            path.moveToPoint(CGPoint(x: 0, y: 1))
            path.addCurveToPoint(CGPoint(x: 1, y: 0.1), controlPoint1: CGPoint(x: 0, y: 0.5), controlPoint2: CGPoint(x: 1, y: 0.5))
            
        case "leaf":
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addCurveToPoint(CGPoint(x: 0.5, y: 0.1), controlPoint1: CGPoint(x: 0.2, y: 0.2), controlPoint2: CGPoint(x: 0.4, y: 0.3))
        
        case "sphere":
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addCurveToPoint(CGPoint(x: 1, y: 1), controlPoint1: CGPoint(x: 0, y: 0.6), controlPoint2: CGPoint(x: 0.4, y: 1))
            path.addCurveToPoint(CGPoint(x: 2, y: 0), controlPoint1: CGPoint(x: 1.6, y: 1), controlPoint2: CGPoint(x: 2, y: 0.6))
            
        default:
            fatalError("Not registered Bezier \(key)")
        }
        let sypath = SYPath(withCGPath: path.CGPath)
        return SYBezier(name: key, path: sypath, options: options)
    }

}