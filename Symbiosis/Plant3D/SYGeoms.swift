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
 * Empty
 **/
struct SYGeomEmptyProps {}

class SYGeomEmpty: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomEmptyProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        let translation: GLKVector3 = GLKVector3Make(0, 0, 0)
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 0, 1)
        return SYBone(translation: translation, orientation: orientation, isLastStep: true)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        return SYStep(points: [])
    }
    
    override func generateMaterial() {
        self.materials = []
    }
    
}


/**
 * Leaf
 **/
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
        
        return SYBone(translation: translation, orientation: orientation, isLastStep: isLastStep)
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




/**
 * Branch
 **/
struct SYGeomBranchProps {
    var size: Float = 1
    var width: Float = 1
    var random: Int = 55666
}

class SYGeomBranch: SYGeom {
    
    let randomsList: [Int] = [421626, 958276, 652741, 340260, 622321, 286666, 74036, 396259, 6922, 485244, 254853, 978128, 618979, 958665, 236668, 868926, 291654, 121005, 612641, 380127, 344277, 456451, 795313, 674856, 418176, 770711, 694530, 491493, 684997, 88605, 631175, 675345, 478007, 142562, 949583, 941762, 484228, 482105, 714422, 995574, 324293, 200815, 521246, 279399, 611019, 699535, 584250, 685657, 320580, 712210]
    
    var randomIndex: Int = 0
    
    func getRandom() -> Int {
        let myProps = self.props as! SYGeomBranchProps
        
        randomIndex = (randomIndex + 1) % randomsList.count
        return randomsList[randomIndex] + myProps.random
    }
    
    override func verifyProps() {
        if !(self.props is SYGeomBranchProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        
        let myProps = self.props as! SYGeomBranchProps
        
        var isLastStep: Bool = false
        let stepSize: Float = 0.1
        let nbrOfSteps = Int(floor(Double(myProps.size) / Double(stepSize)))
        
        var translation: GLKVector3 = GLKVector3Make(0, stepSize, 0)
        var orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 1, 0)
        
        let xAngle = (Float((getRandom() % 2000)-1000) / 1000.0) * 0.2;
        orientation = GLKMatrix4Multiply(orientation, GLKMatrix4MakeRotation(xAngle, 1, 0, 0))
        
        let zAngle = (Float((getRandom() % 2000)-1000) / 1000.0) * 0.2;
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
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        
        let myProps = self.props as! SYGeomBranchProps
        
        let progress: Float = options.bone.sizeFromStart! / options.totalBoneSize
        let progressNum: Float = Float(options.bone.index) / Float(options.nbrOfSteps - 1)
        
        var points: [GLKVector3] = []
        
        let endWidth = myProps.width * 0.5
        let width = myProps.width - ((myProps.width - endWidth) * progress)
        
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
        
        shaders[SCNShaderModifierEntryPointFragment] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("test", ofType: "shader")!, encoding: NSUTF8StringEncoding)
        
        // shaders[SCNShaderModifierEntryPointLightingModel] = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("tooning", ofType: "shader")!, encoding: NSUTF8StringEncoding)
        
        // mat.shaderModifiers = shaders
        
        self.materials = [mat]
    }
    
}


