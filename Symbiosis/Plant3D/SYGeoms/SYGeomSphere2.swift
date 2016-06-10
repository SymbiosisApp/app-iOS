//
//  SYGeomSphere2.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit
import UIKit

/**
 * Sphere2
 **/
struct SYGeomSphere2Props {
    var size: Float = 1
    var orient: GLKMatrix4? = nil
}

class SYGeomSphere2: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomSphere2Props) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomSphere2Props
        
        // Return 0
        if myProps.size == 0 {
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), size: nil, isLastStep: true, isAbsolute: nil)
        }
        
        if options.index == 0 {
            print("------")
        }
        
        let nbrOfSteps = 20
        
        let angle = (Float(options.index) / Float(nbrOfSteps)) * Float(M_PI)
        let stepSize = sin(angle) * myProps.size * 0.008
        
        var isLastStep: Bool = false
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0, 0, 1, 0)
        let translation = GLKVector3Make(0, stepSize, 0)
        
        if (options.index >= nbrOfSteps) {
            isLastStep = true
        }
        
        if options.index == 0 && myProps.orient != nil {
            orientation = GLKMatrix4Multiply(myProps.orient!, orientation)
        }
        
        return SYBone(translation: translation, orientation: orientation, size: nil, isLastStep: isLastStep, isAbsolute: false)
        
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomSphere2Props
        
        if myProps.size == 0 {
            return SYStep(points: [])
        }
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        let angle = (Float(options.bone.index) / Float(options.nbrOfSteps)) * Float(M_PI)
        
        let width: Float = sin(angle) * myProps.size * 0.5 * 0.1
        
        // Last step
        if progressNum == 1 {
            points = [GLKVector3Make(0, 0, 0)]
        } else if progressNum == 0 {
            points = [GLKVector3Make(0, 0, 0)]
        } else {
            let angleStep: Float = Float(M_PI)/(10/2)
            
            for i in 0..<10 {
                let angle = Float(i) * angleStep
                let rotate = GLKMatrix4MakeRotation(angle, 0, 1, 0)
                let point = GLKMatrix4MultiplyAndProjectVector3(rotate, GLKVector3Make(width, 0, 0))
                points.append(point)
            }
            
        }
        
        return SYStep(points: points)
        
    }
    
    override func generateMaterial() {
        
        // let myProps = self.props as! SYGeomBranchProps
        
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        mat.emission.contents = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        mat.doubleSided = true
        
        self.materials = [mat]
    }
    
}


class SYShapeSphere2: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomSphere2Props) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomSphere2Props
            self.geoms.append(SYGeomSphere2(props: newProps, parent: self))
        }
    }
    
}


