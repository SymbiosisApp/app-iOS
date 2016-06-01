//
//  SYRandomManager.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 25/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

//struct SYBezier {
//    let name: String
//    let path: SYPath
//    let options: Equatable?
//    
//    func valueAtTime(time: Float) -> CGPoint {
//        return path.valueAtTime(time)
//    }
//}

//func ==(lhs: SYBezier, rhs: SYBezier) -> Bool {
//    let areEqual = (lhs.name == rhs.name &&
//        lhs.path == rhs.path &&
//        lhs.options! == rhs.options!)
//    return areEqual;
//}

//class SYBezierManager {
//    
//    var beziers: [String: SYBezier] = [:]
//    
//    func get(key: String, options: Any?) -> SYBezier {
//        if self.beziers[key] == nil {
//            self.beziers[key] = self.generateBezier(key, options: options);
//        }
//        return self.beziers[key]!
//    }
//    
//    func generateBezier(key: String, options: Any?) -> SYBezier {
//        let path = UIBezierPath()
//        switch key {
//        case "trunk":
//            path.addLineToPoint(CGPoint(x: 2, y: 2))
//        default:
//            fatalError("Not register ")
//        }
//        let sypath = SYPath(withCGPath: path.CGPath)
//        return SYBezier(name: key, path: sypath, options: options)
//    }
//
//}