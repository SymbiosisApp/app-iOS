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
    var translation: GLKMatrix4
    var rotation: GLKMatrix4
    var isLastStep: Bool
    
    init (translation: GLKMatrix4, rotation: GLKMatrix4, isLastStep: Bool) {
        self.index = nil
        self.translation = translation
        self.rotation = rotation
        self.isLastStep = isLastStep
        self.size = GLKVector3Length(GLKMatrix4MultiplyAndProjectVector3(translation, GLKVector3Make(0, 0, 0)));
    }
}

struct Step {
    var points: [GLKVector3] = []
    var bone: Bone?
    var index: Int?
    var length: Int {
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

class Shape {
    
    var totalBoneSize: Float = 0.0
    var bones: [Bone] = []
    var steps: [Step] = []
    var boneFunc :(options: BoneFuncOptions) -> Bone
    var stepFunc: (options: StepFuncOptions) -> Step
    var options: [String:Any] = [:]
    
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
                print("last step")
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
    
    func setOptions (options: [String:Any]) {
        self.options = options
    }
    
    func execWithOptions (options: [String:Any]) {
        self.setOptions(options)
        
        generateBones()
        generateSteps()
    }
    
}
