//
//  SYStructs.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 12/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit

//MARK: - Structures

/// A bone element of a SYGeom
struct SYBone {
    
    /// Bone index
    var index: Int!
    
    /// Size of this bone only
    var size: Float
    
    /// Size of the bone from the first bone
    var sizeFromStart: Float!
    
    /// The translation of the bone used to generate
    var translation: GLKVector3
    
    /// The orientation of the bone used to generate
    var orientation: GLKMatrix4
    
    /// true if it's the last step
    var isLastStep: Bool
    
    /// The position of the bone (after generate)
    var position: GLKVector3
    
    /// The rotation of the bone (after generate)
    var rotation: GLKMatrix4
    
    var isAbsolute: Bool = false
    
    init (translation: GLKVector3, orientation: GLKMatrix4, size: Float?, isLastStep: Bool, isAbsolute: Bool?) {
        self.index = nil
        self.translation = translation
        self.orientation = orientation
        self.isLastStep = isLastStep
        // Init position and rotation
        self.position = GLKVector3Make(0, 0, 0)
        self.rotation = GLKMatrix4MakeRotation(0, 0, 0, 0)
        if (isAbsolute != nil) {
            self.isAbsolute = isAbsolute!
        }
        if size != nil {
            self.size = size!
        } else {
            self.size = GLKVector3Length(translation)
        }
    }
}

struct SYStep {
    var points: [GLKVector3] = []
    var bone: SYBone!
    var index: Int!
    var count: Int {
        get {
            return self.points.count
        }
    }
    
    init (points: [GLKVector3]) {
        self.points = points
    }
}

struct SYFace {
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

struct SYBoneFuncOptions {
    let bones: [SYBone]
    let index: Int
    let boneSizeFromStart: Float
    
    func getLastOrientation() -> GLKMatrix4 {
        var result = GLKMatrix4MakeRotation(0, 0, 1, 0)
        if bones.count > 0 {
            for bone in bones {
                // print(NSStringFromGLKMatrix4(bone.orientation))
                result = GLKMatrix4Multiply(result, bone.orientation)
            }
        }
        return result
    }
}

struct SYStepFuncOptions {
    let bone: SYBone
    let nbrOfSteps: Int
    let totalBoneSize: Float
}

protocol SYRederable: class {
    func render(progress: Float)
    func getRandomManager() -> SYRandomManager
    func getBezierManager() -> SYBezierManager
}
