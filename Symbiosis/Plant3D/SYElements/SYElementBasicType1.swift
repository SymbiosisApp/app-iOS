//
//  SYElementBasicType1.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit


struct SYElementBasicType1Props {
    let id: String
    var rootProps: SYElementRootProps
}

class SYElementBasicType1: SYElement {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYElementBasicType1Props) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateElemsList() {
        for (propsIndex, props) in propsList.enumerate() {
            let myProps = props as! SYElementBasicType1Props
            //            let numberOfElems = Int((1 + myProps.size) * (1 + myProps.size))
            //            for i in 1...numberOfElems {
            //                let subId = myProps.id + "-branch" + String(i)
            //                let branchRandom = randomManager.get(subId);
            //                let branchMult = UtilsRandom(withRandom: branchRandom, between: 0.5, and: 1.2)
            //
            //                let size = myProps.size * branchMult;
            //                let width: Float = 0.08 + size * 0.01
            //
            //                let childProps = SYGeomBranchProps(size: size, width: width, random: branchRandom)
            //                let name = "subBranch-\(i)"
            //                self.addInElems(name, type: "branchShape", index: index, options: nil, props: childProps, position: nil, orientation: nil)
            //            }

            //            let childProps = SYGeomLeafProps(size: 1, bend: 0.3)
            //            self.addInElems("leaf", type: "leafShape", index: index, options: nil, props: childProps, position: nil, orientation: nil)
            
            let trunkProps = SYGeomTrunkProps(size: myProps.rootProps.size)
            
            let trunkBones: [SYBone] = SYGeomTrunk(withoutGenerateWithProps: trunkProps, parent: self).getBones()

            if myProps.rootProps.hasLeefs {
                for (index, bone) in trunkBones.enumerate() {
                    let pos = GLKVector3Make(bone.position.x, bone.position.y, bone.position.z)
                    let props = SYGeomLeafProps(size: 0.5)
//                    var orient = GLKVector4Make(0, 1, 0, 0)
//                    let rotate = GLKMatrix4MakeRotationToAlign(GLKVector3Make(0, 1, 0), plan: bone.translation, axisRotation: 0)
//                    let orient = GLKQuaternionMakeWithMatrix4(rotate)
//                    let orient = GLKVector4Make(bone.translation.x, bone.translation.y, bone.translation.z, 0)
                    let orient = GLKVector4Make(0, 1, 0, 0)
                    
                    self.addInElems("leaf\(index)", type: "leafShape", propsIndex: propsIndex, options: nil, props: props, position: pos, orientation: GLKVector4Normalize(orient))
                }
            }
            
            self.addInElems("trunk", type: "trunkShape", propsIndex: propsIndex, options: nil, props: trunkProps, position: GLKVector3Make(0, 0, 0), orientation: nil )
            
        }
    }
    
}

