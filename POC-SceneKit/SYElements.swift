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
        let trunk = SYShapeBranch(options: ["size": 1.0])
        self.geometries.addChildNode(trunk)
        
        let bones = trunk.getBones(state)
        var rotate: Float = 0.0
        for bone in bones {
            if bone.index > 0 {
                let leaf = SYShapeLeaf(options: ["size":0.5])
                var rotation = GLKMatrix4MakeWithQuaternion(GLKQuaternionMake(0, 1, 0, 0))
                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(rotate, 0, 1, 0))
                rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(1.2, 0, 0, 1))
                
                let finalRotate = GLKQuaternionMakeWithMatrix4(rotation)
                leaf.orientation = SCNVector4Make(finalRotate.x, finalRotate.y, finalRotate.z, finalRotate.w)
                leaf.position = SCNVector3FromGLKVector3(bone.position)
                self.geometries.addChildNode(leaf)
                rotate += 0.8
            }
        }

    }
    
    override func generateChildren(state: Float) {
//        let options1: [String:Any] = [:]
//        let child = SYShape(options: options1)
//        child.render(state)
//        self.addChildNode(child)
//        child.position = SCNVector3Make(0, 1, 1)
    }
    
    
}