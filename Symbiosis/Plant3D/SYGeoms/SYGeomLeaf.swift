//
//  SYGeomLeaf.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit


struct SYGeomLeafProps {
    var size: Float = 1
    var bend: Float = 0.1
}

class SYGeomLeaf: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomLeafProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomLeafProps
        
        var isLastStep: Bool = false
        let nbrOfSteps = 10
        let stepSize = myProps.size / Float(nbrOfSteps)
        
        var translation: GLKVector3 = GLKVector3Make(0, stepSize, 0)
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(myProps.bend, 0, 0, 1)
        
        if (options.index == 0) {
            translation = GLKVector3Make(0, 0, 0)
        }
        
        if (options.index == nbrOfSteps-1) {
            isLastStep = true
        }
        
        if (options.index > nbrOfSteps-4) {
            translation = GLKVector3Make(0, stepSize/2.0, 0)
        }
        
        return SYBone(translation: translation, orientation: orientation, size: nil, isLastStep: isLastStep, isAbsolute: nil)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomLeafProps
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let index: Int = options.bone.index!
        
        let widths: [Float] = [0.1, 0.2, 0.25, 0.3, 0.35, 0.37, 0.3, 0.25, 0.15]
        
        var points: [GLKVector3] = []
        
        let mult: Float = myProps.size / 5.0
        
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
    
    override func generateMaterial() {
        // let myProps = self.props as! SYGeomLeafProps
        
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor(red: 0.1333, green: 0.3608, blue: 0.7412, alpha: 1)
        mat.doubleSided = true
        
        self.materials = [mat]
    }
    
}


class SYShapeLeaf: SYShape {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomLeafProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomLeafProps
            self.geoms.append(SYGeomLeaf(props: newProps)  )
        }
    }
    
}

