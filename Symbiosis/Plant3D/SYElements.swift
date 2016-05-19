////
////  SYElements.swift
////  POC-SceneKit
////
////  Created by Etienne De Ladonchamps on 11/04/2016.
////  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
////
//
//import Foundation
//import GLKit
//import SceneKit
//
//struct SYElementBranchProps {
//    var size: Float
//    
//    init(size: Float) {
//        self.size = size
//    }
//}
//
//class SYElementBranch: SYElement {
//    
//    override func getProps<SYElementBranchProps>() -> SYElementBranchProps {
//        return self.props as! SYElementBranchProps
//    }
//    
//    override func generateSelfGeom() {
//        
//        let props: SYElementBranchProps = self.getProps()
//        
//        let trunkSize = Float(2.0) * props.size
//        let trunk = SYShapeBranch(options: ["size": trunkSize, "width": Float(0.07) * props.size ])
//        trunk.name = "trunk"
//        self.geometries.addChildNode(trunk)
//        
//        if props.size < 0.3 {
//            return
//        }
//        
//        let steps = trunk.getSteps(props.size)
//        for step in steps {
//            let bone = step.bone
//            // Make is relative
//            let boneVect = GLKMatrix4MultiplyAndProjectVector3(bone.orientation, GLKVector3Normalize(bone.translation))
//            
//            if bone.sizeFromStart > trunkSize * 0.6 {
//                for point in step.points {
//                    let size = 0.4 + (Float((random() % 2000)-1000) / 1000.0) * 0.2;
//                    let leaf = SYShapeLeaf(options: ["size": Float(size) * props.size ])
//                    
//                    let leafVect = GLKVector3Make(0, 1, 0)
//                    
//                    var leafTarget = GLKVector3Normalize(GLKVector3Subtract(bone.position, point))
//                    // Make leafTarget relative
//                    leafTarget = GLKMatrix4MultiplyAndProjectVector3(bone.orientation, leafTarget)
//                    
//                    let verticalAngle = acos(Float(GLKVector3DotProduct(boneVect, leafTarget)))
//                    
//                    // Rotate to y=0
//                    let axis = GLKVector3Normalize(GLKVector3CrossProduct(boneVect, leafTarget))
//                    let angle = Float(M_PI/2)-verticalAngle
//                    let onPlane = GLKMatrix4MultiplyAndProjectVector3(GLKMatrix4MakeRotation(angle, axis.x, axis.y, axis.z), leafTarget)
//                    var horiAngle = acos(Float(GLKVector3DotProduct(GLKVector3Make(0, 0, 1), onPlane)))
//                    if onPlane.x < 0 {
//                        horiAngle = horiAngle * -1
//                    }
//                    horiAngle -= Float(M_PI) / 2
//                    
//                    var rotation = GLKMatrix4MakeRotation(horiAngle, boneVect.x, boneVect.y, boneVect.z)
//                    
//                    
//                    let boneVectPerp = GLKMatrix4MultiplyAndProjectVector3(GLKMatrix4MakeRotation(Float(M_PI)/2.0, 1, 0, 0), leafVect)
//                    rotation = GLKMatrix4Multiply(rotation, GLKMatrix4MakeRotation(1.2, boneVectPerp.x, boneVectPerp.y, boneVectPerp.z))
//                    
//                    let quat = GLKQuaternionMakeWithMatrix4(rotation)
//                    let rotationAxis = GLKQuaternionAxis(quat)
//                    leaf.rotation = SCNVector4Make(rotationAxis.x, rotationAxis.y, rotationAxis.z, GLKQuaternionAngle(quat))
//                    leaf.position = SCNVector3FromGLKVector3(point)
//                    self.geometries.addChildNode(leaf)
//                }
//            }
//        }
//        
//    }
//    
//    override func generateChildren() {
//        
//        let props: SYElementBranchProps = self.getProps()
//        
//        let trunk = self.geometries.childNodeWithName("trunk", recursively: false) as! SYShape
//        let bones = trunk.getBones(props.size)
//        let position = bones[7].position
//        if (props.size > 0.3) {
//            let child = SYElementBranch()
//            child.name = "first"
//            child.position = SCNVector3FromGLKVector3(position)
//            self.children.addChildNode(child)
//        }
//        if (props.size > 0.6) {
//            let child = SYElementBranch()
//            child.name = "second"
//            child.position = SCNVector3FromGLKVector3(position)
//            self.children.addChildNode(child)
//        }
//    }
//    
//}