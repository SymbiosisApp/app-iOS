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
        
        let myPath = self.parent.getBezierManager().get("trunk", options: nil)
        
        let maxSize: Float = 9
        let progressOnMax = (8 + (1 - pow(Float(M_E), (-0.1 * myProps.size)))) / maxSize
        let progressCurve = progressOnMax * (options.boneSizeFromStart / myProps.size)
        
        let multiplier: Float = (1 - pow(Float(M_E), (-0.1 * myProps.size))) * 3
        
        let point = myPath.valueAtTime(progressCurve)
        let nextPoint = myPath.valueAtTime(progressCurve + 0.01)
        let translation = GLKVector3Make(Float(point.x) * multiplier, Float(point.y) * multiplier, 0)
        let nextTranslate = GLKVector3Make(Float(nextPoint.x) * multiplier, Float(nextPoint.y) * multiplier, 0)
        orientation = GLKMatrix4MakeRotationToAlignGLKVector3(GLKVector3Subtract(nextTranslate, translation), plan: GLKVector3Make(0, 1, 0), axisRotation: options.boneSizeFromStart/10 )
        
        if (options.boneSizeFromStart > myProps.size) {
            isLastStep = true
        }
        
        if options.bones.count >= 2 {
            let dist = GLKVector3Distance(options.bones[0].translation, options.bones[1].translation)
            print("dist : \(dist)")
        }
        
        return SYBone(translation: translation, orientation: orientation, size: 0.05, isLastStep: isLastStep, isAbsolute: true)
        
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomTrunkProps
        
        if myProps.size == 0 {
            return SYStep(points: [])
        }
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        // let myPath = self.parent.getBezierManager().get("trunk-width", options: nil)
        
        // let width: Float = (Float(myPath.valueAtTime(progress).y) / 10) * 0.5 // * (myProps.size / 10)
  
        // let width = 0.1 * (1 - progress)
        
        
        var width = (1 - pow(Float(M_E), (-0.1 * myProps.size))) * 0.1
        width = width * (1 - progress)
        
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
        //mat.diffuse.contents = UIColor(red: 255/255, green: 204/255, blue: 184/255, alpha: 1)
        mat.diffuse.contents = UIColor(red: 255/255, green: 156/255, blue: 142/255, alpha: 1)
        // mat.emission.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        mat.doubleSided = true
        
//        var shaders: [String:String] = [:]
//        
//        shaders[SCNShaderModifierEntryPointFragment] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("test", ofType: "fsh")!, encoding: NSUTF8StringEncoding)
//        
//        // shaders[SCNShaderModifierEntryPointLightingModel] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("tooning", ofType: "fsh")!, encoding: NSUTF8StringEncoding)
//        
//        mat.shaderModifiers = shaders
        
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
            self.geoms.append(SYGeomTrunk(props: newProps, parent: self))
        }
    }
    
}


