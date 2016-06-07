//
//  SYGeomSphere.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit

/**
 * Sphere
 **/
struct SYGeomSphereProps {
    var size: Float = 1
}

class SYGeomSphere: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomSphereProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomSphereProps
        
        // Return 0
        if myProps.size == 0 {
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), size: nil, isLastStep: true, isAbsolute: nil)
        }
        
        var isLastStep: Bool = false
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 1, 0)
        let translation = GLKVector3Make(0, myProps.size/20, 0)
        
        if (options.index > 20) {
            isLastStep = true
        }
        
        return SYBone(translation: translation, orientation: orientation, size: nil, isLastStep: isLastStep, isAbsolute: false)
        
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomSphereProps
        
        if myProps.size == 0 {
            return SYStep(points: [])
        }
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        let myPath = self.parent.getBezierManager().get("sphere", options: nil)
        
        let width: Float = (Float(myPath.valueAtTime(progress).y) / 10) * 0.5 // * (myProps.size / 10)
        
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


class SYShapeSphere: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomSphereProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomSphereProps
            self.geoms.append(SYGeomSphere(props: newProps, parent: self))
        }
    }
    
}


