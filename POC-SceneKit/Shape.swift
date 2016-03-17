//
//  ShapeMaker.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 25/02/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit
import GLKit

// Structures

struct Bone {
    var index: Int?
    var size: Float
    var sizeFromStart: Float?
    var translation: GLKVector3
    var rotation: GLKMatrix4
    var isLastStep: Bool
    
    init (translation: GLKVector3, rotation: GLKMatrix4, isLastStep: Bool) {
        self.index = nil
        self.translation = translation
        self.rotation = rotation
        self.isLastStep = isLastStep
        self.size = GLKVector3Length(translation);
    }
}

struct Step {
    var points: [GLKVector3] = []
    var bone: Bone?
    var index: Int?
    var count: Int {
        get {
            return self.points.count
        }
    }
    
    init (points: [GLKVector3]) {
        self.points = points
    }
}

struct Face {
    var points: [GLKVector3] = []
    var count: Int {
        get {
            return self.points.count
        }
    }
    
    init (points: [GLKVector3]) {
        self.points = points
    }
}

struct BoneFuncOptions {
    let bones: [Bone]
    let index: Int
    let boneSizeFromStart: Float
    var options: [String:Any] = [:]
}

struct StepFuncOptions {
    let bone: Bone
    let nbrOfSteps: Int
    let totalBoneSize: Float
    var options: [String:Any] = [:]
}


// The Class

class Shape : CustomStringConvertible {
    
    var totalBoneSize: Float = 0.0
    var bones: [Bone] = []
    var steps: [Step] = []
    var faces: [[Face]] = []
    
    var boneFunc :(options: BoneFuncOptions) -> Bone
    var stepFunc: (options: StepFuncOptions) -> Step
    var options: [String:Any] = [:]
    
    var description: String {
        get {
            func debugVector (vect: GLKVector3) -> String {
                return "x: \(vect.x) y: \(vect.y) z: \(vect.z)"
            }
            
            var result = "Shape : \n"
            
            for step in self.steps {
                result += "-----\n"
                for point in step.points {
                    result += debugVector(point) + "\n"
                }
            }
            
            return result
        }
    }
    
    init (
        boneFunc: (options: BoneFuncOptions) -> Bone,
        stepFunc: (options: StepFuncOptions) -> Step
    ) {
        self.boneFunc = boneFunc
        self.stepFunc = stepFunc
    }
    
    func generateBones () {
        var isLastStep: Bool = false
        var stepIndex: Int = 0;
        var boneSizeFromStart: Float = 0.0
        
        repeat {
            // Create options struct
            let options = BoneFuncOptions(
                bones: self.bones,
                index: stepIndex,
                boneSizeFromStart: boneSizeFromStart,
                options: self.options
            )
            // Exec func
            var bone = self.boneFunc(options: options)
            // set index
            bone.index = stepIndex
            // set sizeFromStart
            bone.sizeFromStart = boneSizeFromStart
            // Append the bone
            self.bones.append(bone);
            
            isLastStep = bone.isLastStep
            
            if (!isLastStep) {
                ++stepIndex
                boneSizeFromStart += bone.size
            } else {
//                print("last step")
            }
        
        } while (!isLastStep)
        
        self.totalBoneSize = boneSizeFromStart
    }
    
    func generateSteps () {
        for bone in self.bones {
            // Create options
            let options = StepFuncOptions(
                bone: bone,
                nbrOfSteps: self.bones.count,
                totalBoneSize: self.totalBoneSize,
                options: self.options
            )
            // Exec func
            var step = self.stepFunc(options: options)
            // set index
            step.index = bone.index
            self.steps.append(step)
        }
    }
    
    func resolveStepsPositions () {
        var bonePosition: GLKVector3 = GLKVector3Make(0, 0, 0)
        var boneRotation: GLKMatrix4 = GLKMatrix4MakeTranslation(0, 0, 0)
        print(boneRotation)
        for var i = 0; i < self.bones.count; ++i {
            let bone: Bone = self.bones[i]
            var step: Step = self.steps[i]
            
            // Convert step points
            for var j = 0; j < step.points.count; ++j {
                let point: GLKVector3 = step.points[j]
                let rotatedPoint: GLKVector3 = GLKMatrix4MultiplyAndProjectVector3(boneRotation, point)
                self.steps[i].points[j] = GLKVector3Add(bonePosition, rotatedPoint)
            }
            
            // Apply bone
            let boneTranslationAfterRotation: GLKVector3 = GLKMatrix4MultiplyAndProjectVector3(bone.rotation, bone.translation)
            bonePosition = GLKVector3Add(bonePosition, boneTranslationAfterRotation)
            boneRotation = GLKMatrix4Multiply(boneRotation, bone.rotation)
        }
    }
    
    func createFaces () {
        
        for var index = 0; index < self.steps.count-1; ++index {
//            print("step ========")
            let step = self.steps[index]
            let nextStep = self.steps[index+1]
            
            var leftIndex = 0
            var rightIndex = 0
            
            var stepFaces: [Face] = []
            
            let nbrOfFaces = step.count + nextStep.count
            
            for _ in 0...nbrOfFaces {
//                print("face -------")
//                print("\(leftIndex) \(rightIndex)")
                
                var points: [GLKVector3] = []
                points += [step.points[leftIndex % step.count]]
                points += [nextStep.points[rightIndex % nextStep.count]]
                
                let nextLeftInterpolate = Float(leftIndex+1) / Float(step.count+1)
                let nextRightInterpolate = Float(rightIndex+1) / Float(nextStep.count+1)
                
                if (nextLeftInterpolate <= nextRightInterpolate) {
                    ++leftIndex
                    points += [step.points[leftIndex % step.count]]
                } else {
                    ++rightIndex
                    points += [nextStep.points[leftIndex % nextStep.count]]
                }
                
                stepFaces += [Face(points: points)]
            }
            
            self.faces += [stepFaces]
        }
        
        
        
        for i in faces {
            print("Face group ========")
            for j in i {
                print("  Face -------")
                for p in j.points {
                    print("    (\(p.x), \(p.y), \(p.z))")
                }
            }
        }
        
    }
    
    func createGeomData () {
        for face in self.faces {
            
        }
    }
    
    func setOptions (options: [String:Any]) {
        self.options = options
    }
    
    func execWithOptions (options: [String:Any]) {
        self.setOptions(options)
        
        self.generateBones()
        self.generateSteps()
        self.resolveStepsPositions()
        self.createFaces()
        self.createGeomData()
    }
    
}
