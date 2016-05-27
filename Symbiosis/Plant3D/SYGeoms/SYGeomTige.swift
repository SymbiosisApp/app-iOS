//
//  SYGeomTige.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation




/**
 * Tige
 **/
struct SYGeomTigeProps {
    let size: Float;
    let bend: Float;
    let width: Float;
}

class SYGeomTige: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomTigeProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomTigeProps
        
        if myProps.size == 0 {
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), isLastStep: true)
        }
        
        var isLastStep: Bool = false
        let stepSize: Float = 0.3
        
        var translation: GLKVector3 = GLKVector3Make(0, stepSize, 0)
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0, 0, 1, 0)
        
        let bend: Float = myProps.bend * Float(pow(0.9, Float(options.index)))
        orientation = GLKMatrix4Multiply(orientation, GLKMatrix4MakeRotation(bend, 1, 0, 0))
        
        if (options.index == 0) {
            translation = GLKVector3Make(0, 0, 0)
            orientation = GLKMatrix4MakeYRotation(0)
        }
        if (options.index == 1) {
            translation = GLKVector3Make(0, stepSize*0.3, 0)
        }
        if (options.boneSizeFromStart > myProps.size) {
            isLastStep = true
            translation = GLKVector3Make(0, stepSize*0.3, 0)
        }
        
        return SYBone(translation: translation, orientation: orientation, isLastStep: isLastStep)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomTigeProps
        
        if myProps.size == 0 {
            return SYStep(points: [])
        }
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        let width = myProps.width * myProps.size * (1 - progress)
        
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
    
    override func generateMaterial() {
        
        // let myProps = self.props as! SYGeomBranchProps
        
        let mat = SCNMaterial()
        // mat.diffuse.contents = UIColor(red: 1.0, green: 0.6118, blue: 0.5608, alpha: 1)
        mat.diffuse.contents = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1)
        // mat.emission.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        mat.doubleSided = true
        
        self.materials = [mat]
    }
    
}



class SYShapeTige: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomTigeProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomTigeProps
            self.geoms.append(SYGeomTige(props: newProps)  )
        }
    }
    
}
