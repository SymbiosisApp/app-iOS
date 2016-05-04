//
//  SYShapes.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 29/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit


/**
 * Options
 *    "size" : Float
 *    "rotate" : Float
 **/
class SYShapeTwist: SYShape {
    
    override func boneFunc (options: SYBoneFuncOptions, state: Float) -> SYBone {
        var isLastStep: Bool = false
        let nbrOfSteps = 20
        let size = 4.0 / Float(nbrOfSteps)
        if (options.index == nbrOfSteps) {
            isLastStep = true
        }
        
        var rotate: Float? = options.options["rotate"] as? Float
        if rotate == nil {
            rotate = Float(0)
        }
        rotate = rotate! / Float(nbrOfSteps)
        
        let translation: GLKVector3 = GLKVector3Make(0, size, 0)
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(rotate!, 0, 1, 0)
        
        return SYBone(translation: translation, orientation: orientation, isLastStep: isLastStep)
    }
    
    override func stepFunc (options: SYStepFuncOptions, state: Float) -> SYStep {
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        print(progress)
        
        var points: [GLKVector3] = []
        
        var mult: Float? = options.options["size"] as? Float
        if mult == nil {
            mult = Float(1)
        }
        
        // Last step
        if progress == 1 {
            points = [GLKVector3Make(0, 0, 0)]
        } else {
            points += [GLKVector3Make(1*mult!, 0, 1*mult!)]
            points += [GLKVector3Make(1*mult!, 0, -1*mult!)]
            points += [GLKVector3Make(-1*mult!, 0, -1*mult!)]
            points += [GLKVector3Make(-1*mult!, 0, 1*mult!)]
        }
        
        return SYStep(points: points)
    }
    
    override func generateMaterial(options: [String:Any]) -> [SCNMaterial] {
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor(red: 0.5, green: 1, blue: 1, alpha: 1)
        mat.doubleSided = true
        
        return [mat]
    }
    
}



/**
 * Options
 *    "size" : Float
 **/
class SYShapeLeaf: SYShape {
    
    override func boneFunc (options: SYBoneFuncOptions, state: Float) -> SYBone {
        
        let size = (options.options["size"] as? Float) ?? 1.0
        
        var isLastStep: Bool = false
        let nbrOfSteps = 10
        let stepSize = size / Float(nbrOfSteps)
        
        var translation: GLKVector3 = GLKVector3Make(0, stepSize, 0)
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 0, 1)
        
        if (options.index == 0) {
            translation = GLKVector3Make(0, 0, 0)
        }
        
        if (options.index == nbrOfSteps-1) {
            isLastStep = true
        }
        
        if (options.index > nbrOfSteps-4) {
            translation = GLKVector3Make(0, stepSize/2.0, 0)
        }
        
        return SYBone(translation: translation, orientation: orientation, isLastStep: isLastStep)
    }
    
    override func stepFunc (options: SYStepFuncOptions, state: Float) -> SYStep {
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let index: Int = options.bone.index!
        
        let widths: [Float] = [0.1, 0.2, 0.25, 0.3, 0.35, 0.37, 0.3, 0.25, 0.15]
        
        var points: [GLKVector3] = []
        
        let size = options.options["size"] as? Float ?? 1.0
        
        let mult: Float = size / 5.0
        
        // Last step
        if progress == 1 {
            points = [GLKVector3Make(0, 0, 0)]
        } else if progress == 0 {
            points = [GLKVector3Make(0, 0, 0)]
        } else {
            let dist: Float = widths[index-1]
            points.append(GLKVector3Make(dist*0.5*mult, 0, 0))
            points.append(GLKVector3Make(dist*1*mult, 0, -dist*3*mult))
            points.append(GLKVector3Make(-dist*0.5*mult, 0, 0))
            points.append(GLKVector3Make(dist*1*mult, 0, dist*3*mult))
        }
        
        
        
        return SYStep(points: points)
    }
    
    override func generateMaterial(options: [String:Any]) -> [SCNMaterial] {
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor(red: 0.1529, green: 0.6824, blue: 0.3765, alpha: 1)
        mat.doubleSided = true
        
        return [mat]
    }
    
}





/**
 * Options
 *    "size" : Float
 **/
class SYShapeBranch: SYShape {
    
    override func boneFunc (options: SYBoneFuncOptions, state: Float) -> SYBone {
        
        let size = options.options["size"] as? Float ?? 1.0
        
        var isLastStep: Bool = false
        let nbrOfSteps = 20
        let stepSize = size / Float(nbrOfSteps)
        
        var translation: GLKVector3 = GLKVector3Make(0, stepSize, 0)
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 1, 0)
        
        let xAngle = (Float((random() % 2000)-1000) / 1000.0) * 0.2;
        orientation = GLKMatrix4Multiply(orientation, GLKMatrix4MakeRotation(xAngle, 1, 0, 0))
        
        let zAngle = (Float((random() % 2000)-1000) / 1000.0) * 0.2;
        orientation = GLKMatrix4Multiply(orientation, GLKMatrix4MakeRotation(zAngle, 0, 0, 1))
        
        if (options.index == 0) {
            translation = GLKVector3Make(0, 0, 0)
        }
        
        if (options.index == nbrOfSteps-1) {
            isLastStep = true
            translation = GLKVector3Make(0, stepSize*0.3, 0)
        }
        
        return SYBone(translation: translation, orientation: orientation, isLastStep: isLastStep)
    }
    
    override func stepFunc (options: SYStepFuncOptions, state: Float) -> SYStep {
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)        
        
        var points: [GLKVector3] = []
        
//        let size = options.options["size"] as? Float ?? 3.0
        let baseWidth = options.options["width"] as? Float ?? 0.2
        let endWidth = baseWidth * 0.5
        let width = baseWidth - ((baseWidth - endWidth) * progress)
        
        // Last step
        if progressNum == 1 {
            points = [GLKVector3Make(0, 0, 0)]
        } else if progressNum == 0 {
            points = [GLKVector3Make(0, 0, 0)]
        } else {
            let angleStep: Float = Float(M_PI)/3.0
            
            for i in 0...5 {
                let angle = Float(i) * angleStep
                let rotate = GLKMatrix4MakeRotation(angle, 0, 1, 0)
                let point = GLKMatrix4MultiplyAndProjectVector3(rotate, GLKVector3Make(width, 0, 0))
                points.append(point)
            }
            
        }
        
        return SYStep(points: points)
    }
    
    override func generateMaterial(options: [String:Any]) -> [SCNMaterial] {
        let mat = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "leaf.png")
        mat.diffuse.contents = UIColor(red: 0.1294, green: 0.3706, blue: 0.1745, alpha: 1)
        // mat.emission.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        mat.doubleSided = true
        
        return [mat]
    }
    
}



