//
//  SYGeomTige.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit


/**
 * Tige
 **/
struct SYGeomTigeProps {
    let size: Float;
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
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), size: nil, isLastStep: true, isAbsolute: nil)
        }
        
        var isLastStep: Bool = false
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0, 0, 1, 0)
        
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addCurveToPoint(CGPoint(x: 2, y: 0), controlPoint1: CGPoint(x: 0, y: 1), controlPoint2: CGPoint(x: 2, y: 1))
        let myBezier = SYPath(withCGPath: path.CGPath)
        
        let maxSize: Float = 10
        let progressOnMax = myProps.size / maxSize
        let progressCurve = progressOnMax * (options.boneSizeFromStart / myProps.size)
        
        let point = myBezier.valueAtTime(progressCurve)
        let nextPoint = myBezier.valueAtTime(progressCurve + 0.01)
        let translation = GLKVector3Make(Float(point.y) * 1, Float(point.x) * 1, 0)
        let nextTranslate = GLKVector3Make(Float(nextPoint.y) * 1, Float(nextPoint.x) * 1, 0)
        orientation = GLKMatrix4MakeRotationToAlign(GLKVector3Subtract(nextTranslate, translation), plan: GLKVector3Make(0, 1, 0), axisRotation: options.boneSizeFromStart/10 )
        
        if (options.boneSizeFromStart > myProps.size) {
            isLastStep = true
        }
        
        return SYBone(translation: translation, orientation: orientation, size: 0.1, isLastStep: isLastStep, isAbsolute: true)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomTigeProps
        
        if myProps.size == 0 {
            return SYStep(points: [])
        }
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 1))
        path.addCurveToPoint(CGPoint(x: 1, y: 0.5), controlPoint1: CGPoint(x: 0, y: 0.5), controlPoint2: CGPoint(x: 1, y: 0.5))
        let myBezier = SYPath(withCGPath: path.CGPath)
        let width: Float = (Float(myBezier.valueAtTime(progress).y) / 10) * (myProps.size / 5)
        
        // let width = myProps.width * myProps.size * (1 - progress)
        
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
