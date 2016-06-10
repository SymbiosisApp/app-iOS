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
            
            let trunkSize = myProps.rootProps.size * 2
            
            let trunkProps = SYGeomTrunkProps(size: trunkSize)
            
            let trunkGeom = SYGeomTrunk(withoutGenerateWithProps: trunkProps, parent: self)
            let trunkBones: [SYBone] = trunkGeom.getBones()
            
            // if myProps.rootProps.hasLeefs {
                for (index, bone) in trunkBones.enumerate() {

                    let progress = Float(bone.index) / Float(trunkBones.count)
                    
                    if progress > 0.3 && progress < 0.9 {
                        
                        let leafId = "\(myProps.id)-leafs-\(index)"
                        let pos = GLKVector3Make(bone.position.x, bone.position.y, bone.position.z)
                        var orient = bone.orientation
                        let leafSize = 0.1 + (1 - progress) * myProps.rootProps.size
                        
                        let nbrOfLeafs = self.parent.getRandomManager().get("\(leafId)-number") % 3
                        for i in 0..<nbrOfLeafs {
                            let leafRotateY = Float(self.parent.getRandomManager().get("\(leafId)-\(i)") % 1000) / 1000
                            orient = GLKMatrix4Multiply(orient, GLKMatrix4MakeYRotation(leafRotateY * 2 * Float(M_PI)))
                            let props = SYGeomLeafProps(size: leafSize, firstRotation: orient, id: leafId )
                            self.addInElems("\(leafId)-\(i)", type: "leafShape", propsIndex: propsIndex, options: nil, props: props, position: pos, orientation: nil)
                        }
                    }

                }
            // }
            
            self.addInElems("trunk", type: "trunkShape", propsIndex: propsIndex, options: nil, props: trunkProps, position: GLKVector3Make(0, 0, 0), orientation: GLKVector4Make(0, 0, 0, 0) )
            
            
//            let flowerProps = SYElementFlower1Props(id: "flower", size: myProps.rootProps.size * 0.3, rootProps: myProps.rootProps)
//            self.addInElems("flower", type: "flowerElem", propsIndex: propsIndex, options: nil, props: flowerProps, position: trunkBones.last?.position, orientation: nil)
//            
            
            let rootSize = myProps.rootProps.size
            
            if trunkBones.count > 1  {
                
                // Sphere 1
                let nbrOfSphere = Int(rootSize*6)
                
                for i in 0..<nbrOfSphere {
                    let sphereRan = self.parent.getRandomManager().get("\(myProps.id)-sphere2-\(i)")
                    let posX = ((Float(sphereRan%33454) / 33454)*2 - 1) * rootSize * 0.05
                    let posY = ((Float(sphereRan%77655) / 77655)*2 - 1) * rootSize * 0.05
                    let posZ = ((Float(sphereRan%99876) / 99876)*2 - 1) * rootSize * 0.05
                    let size = 0.2 + (Float(sphereRan%6787) / 6787) * rootSize * 0.05
                    let spherePos = GLKVector3Add(trunkBones.last!.position, GLKVector3Make(posX, posY, posZ))
                    let sphereProps = SYGeomSphere2Props(size: size, orient: nil)
                    self.addInElems("sphere2-\(i)", type: "sphere2Shape", propsIndex: propsIndex, options: nil, props: sphereProps, position: spherePos, orientation: nil)
                }
                
//                spherePos = GLKVector3Add(trunkBones.last!.position, GLKVector3Make(0.03 * rootSize, 0.01 * rootSize, 0.02 * rootSize))
//                let sphereProps2 = SYGeomSphere2Props(size: myProps.rootProps.size * 0.1, orient: nil)
//                self.addInElems("sphere3", type: "sphere2Shape", propsIndex: propsIndex, options: nil, props: sphereProps2, position: spherePos, orientation: nil)
                
                
                // let middle = (trunkBones.last?.position.y)! * 0.25
                self.addInElems("sphere", type: "sphereShape", propsIndex: propsIndex, options: nil, props: SYGeomSphereProps(size: myProps.rootProps.size * 0.6, orient: trunkBones[0].orientation), position: trunkBones[0].position, orientation: nil )
            }
            
        }
    }
    
}

