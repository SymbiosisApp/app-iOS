//
//  Utils.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 12/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

enum InterpolatorError : ErrorType {
    case RuntimeError(String)
}

class Interpolator {
    
    var points: [Float]
    
    init(points: [Float]) {
        if points.count < 2 {
            print("Points must contain more than 1 elements (get \(points.count))")
        }
        self.points = points
    }
    
    func valueAt(progress: Float) -> Float {
        if progress < 0 || progress > 1 {
            print("Progress must be between 0 and 1 (get \(progress))")
            return 0
        }
        let pointsSize = points.count
        let index = progress * Float(pointsSize)
        if floor(index) == index {
            return points[Int(index)]
        }
        let pointBefore = points[Int(floor(index))]
        let pointAfter = points[Int(floor(index) + 1)]
        let diff = index - floor(index)
        let result = pointBefore + ((pointAfter - pointBefore) * diff)
        return result
    }
    
}