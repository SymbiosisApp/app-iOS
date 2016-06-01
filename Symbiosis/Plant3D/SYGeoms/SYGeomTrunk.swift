//
//  SYGeomTrunk.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit

/**
 * Trunk
 **/
struct SYGeomTrunkProps {
    var size: Float = 1
}

class SYGeomTrunk: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomTrunkProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomTrunkProps
        
        // Return 0
        if myProps.size == 0 {
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), size: nil, isLastStep: true, isAbsolute: nil)
        }
        
        var isLastStep: Bool = false
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0, 0, 1, 0)
        
        // Path
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0.3, y: 0.2))
        path.addCurveToPoint(CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0.3, y: 0.1), controlPoint2: CGPoint(x: 0.2, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: 4))
//        path.addCurveToPoint(CGPoint(x: -0.2, y: 0.2), controlPoint1: CGPoint(x: -0.1, y: 0), controlPoint2: CGPoint(x: -0.2, y: 0.1))
//        path.addCurveToPoint(CGPoint(x: 0.2, y: 0.8), controlPoint1: CGPoint(x: -0.2, y: 0.5), controlPoint2: CGPoint(x: 0.2, y: 0.6))
//        path.addCurveToPoint(CGPoint(x: 0, y: 1), controlPoint1: CGPoint(x: 0.2, y: 0.9), controlPoint2: CGPoint(x: 0.1, y: 1))
        let myPath = SYPath(withCGPath: path.CGPath)
        
        let maxSize: Float = 10.2
        let progressOnMax = myProps.size / maxSize
        let progressCurve = progressOnMax * (options.boneSizeFromStart / myProps.size)
        
        let multiplier: Float = 3
        let point = myPath.valueAtTime(progressCurve)
        let nextPoint = myPath.valueAtTime(progressCurve + 0.01)
        let translation = GLKVector3Make(Float(point.x) * multiplier, Float(point.y) * multiplier, 0)
        let nextTranslate = GLKVector3Make(Float(nextPoint.x) * multiplier, Float(nextPoint.y) * multiplier, 0)
        orientation = GLKMatrix4MakeRotationToAlign(GLKVector3Subtract(nextTranslate, translation), plan: GLKVector3Make(0, 1, 0), axisRotation: options.boneSizeFromStart/10 )
        
        // print(point)
        // print("\(progressCurve) => \(point)")
        
        if (options.boneSizeFromStart > myProps.size) {
            isLastStep = true
        }
        
        // print(NSStringFromGLKVector3(translation))
        
        return SYBone(translation: translation, orientation: orientation, size: 0.1, isLastStep: isLastStep, isAbsolute: true)
        
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomTrunkProps
        
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
        let width: Float = (Float(myBezier.valueAtTime(progress).y) / 10) * 0.5 // * (myProps.size / 10)
        
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
        mat.diffuse.contents = UIColor(red: 1.0, green: 0.6118, blue: 0.5608, alpha: 1)
        // mat.emission.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        mat.doubleSided = true
        
        var shaders: [String:String] = [:]
        
        shaders[SCNShaderModifierEntryPointFragment] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("test", ofType: "fsh")!, encoding: NSUTF8StringEncoding)
        
        // shaders[SCNShaderModifierEntryPointLightingModel] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("tooning", ofType: "fsh")!, encoding: NSUTF8StringEncoding)
        
        mat.shaderModifiers = shaders
        
        self.materials = [mat]
    }
    
}


class SYShapeTrunk: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomTrunkProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomTrunkProps
            self.geoms.append(SYGeomTrunk(props: newProps)  )
        }
    }
    
}