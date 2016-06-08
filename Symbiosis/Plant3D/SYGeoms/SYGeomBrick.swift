//
//  SYGeomBrick.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit

/**
 * Brick
 **/
struct SYGeomBrickProps {
    var size: Float = 1
}

class SYGeomBrick: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomBrickProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomBrickProps
        
        // Return 0
        if myProps.size == 0 {
            return SYBone(translation: GLKVector3Make(0, 0, 0), orientation: GLKMatrix4MakeRotation(0, 0, 1, 0), size: nil, isLastStep: true, isAbsolute: nil)
        }
        
        var isLastStep = false
        
        let translation = GLKVector3Make(0, 0.1, 0)
        let orientation = GLKMatrix4MakeXRotation(0.2)
        
        if options.index >= 10 {
            isLastStep = true
        }
        
        return SYBone(translation: translation, orientation: orientation, size: nil, isLastStep: isLastStep, isAbsolute: false)
        
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomBrickProps
        
        var points = [GLKVector3]()
        
        points.append(GLKVector3Make(-0.01, 0, -0.01))
        points.append(GLKVector3Make(0.01, 0, -0.01))
        points.append(GLKVector3Make(0.01, 0, 0.01))
        points.append(GLKVector3Make(-0.01, 0, 0.01))
        
        return SYStep(points: points)
        
    }
    
    override func generateMaterial() {
        
        // let myProps = self.props as! SYGeomBranchProps
        
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1)
        // mat.emission.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        mat.doubleSided = true
        
        self.materials = [mat]
    }
    
}


class SYShapeBrick: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomBrickProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomBrickProps
            self.geoms.append(SYGeomBrick(props: newProps, parent: self))
        }
    }
    
}



