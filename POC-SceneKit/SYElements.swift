//
//  SYElements.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 11/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit

class SYElementBranch: SYElement {
    
    override func generateSelfGeom(state: Float) {
        let trunk = SYShapeBranch(options: ["size": Float(1.0) ])
        self.geometries.addChildNode(trunk)
        
//        let bones = trunk.getBones(state)
//        var rotate: Float = 0.0
//        for bone in bones {
//            if bone.index > 0 {
//                let leaf = SYShapeLeaf(options: ["size": Float(0.5) ])
//                var rotation = GLKMatrix4MakeWithQuaternion(GLKQuaternionMake(0, 1, 0, 0))
//                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(rotate, 0, 1, 0))
//                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(1.2, 0, 0, 1))
//                
//                let finalRotate = GLKQuaternionMakeWithMatrix4(rotation)
//                leaf.orientation = SCNVector4Make(finalRotate.x, finalRotate.y, finalRotate.z, finalRotate.w)
//                leaf.position = SCNVector3FromGLKVector3(bone.position)
//                self.geometries.addChildNode(leaf)
//                rotate += 0.8
//            }
//        }
        
        let steps = trunk.getSteps(state)
        for step in steps {
            let bone = step.bone
            for point in step.points {
                let leaf = SYShapeLeaf(options: ["size": Float(0.2) ])
                    
                let boneToStep = GLKVector3Subtract(bone.position, point)
                let initQuat = GLKQuaternionMake(0, 1, 0, 0)
                var rotation = GLKMatrix4MakeWithQuaternion(initQuat)
                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(1.2, 0, 0, 1))
                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeWithQuaternion(GLKQuaternionMakeWithVector3(boneToStep, 1)))
                    
                let finalRotate = GLKQuaternionMakeWithMatrix4(rotation)
                leaf.orientation = SCNVector4Make(finalRotate.x, finalRotate.y, finalRotate.z, finalRotate.w)
                leaf.position = SCNVector3FromGLKVector3(point)
                self.geometries.addChildNode(leaf)
            }
        }

    }
    
    override func generateChildren(state: Float) {
//        if (state > 0.5) {
//            let child = SYElementBranch()
//            child.name = "first"
//            self.children.addChildNode(child)
//        }
    }
    
    override func transformStateForChild(child: SYElement, state: Float) -> Float {
        if child.name == "first" {
            
        }
        return state
    }
    
    
    
    
}