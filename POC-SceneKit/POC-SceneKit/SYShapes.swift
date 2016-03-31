//
//  SYShapes.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 29/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit

// The Class


/**
 * Options
 *    "size" : Float
 *    "rotate" : Float
 **/
class SYShapeTwist: SYShape {
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        var isLastStep: Bool = false
        let nbrOfSteps = 50
        let size = 10.0 / Float(nbrOfSteps)
        if (options.index == nbrOfSteps) {
            isLastStep = true
        }
        
        var rotate: Float = options.options["rotate"] as! Float
        rotate = rotate / Float(nbrOfSteps)
        
        let translation: GLKVector3 = GLKVector3Make(0, size, 0)
        let rotation: GLKMatrix4 = GLKMatrix4MakeRotation(rotate, 0, 1, 0)
        
        return SYBone(translation: translation, rotation: rotation, isLastStep: isLastStep)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        print(progress)
        
        var points: [GLKVector3] = []
        
        let mult: Float = options.options["size"] as! Float
        
        // Last step
        if progress == 1 {
            points = [GLKVector3Make(0, 0, 0)]
        } else {
            points += [GLKVector3Make(1*mult, 0, 1*mult)]
            points += [GLKVector3Make(1*mult, 0, -1*mult)]
            points += [GLKVector3Make(-1*mult, 0, -1*mult)]
            points += [GLKVector3Make(-1*mult, 0, 1*mult)]
        }
        
        return SYStep(points: points)
    }
    
}