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
    let id: String;
    var size: Float = 1;
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
        for (index, props) in propsList.enumerate() {
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
            let childProps = SYGeomLeafProps(size: 1, bend: 0.3)
            self.addInElems("leaf", type: "leafShape", index: index, options: nil, props: childProps, position: nil, orientation: nil)
            
            let tigeProps = SYGeomTigeProps(size: 1, bend: 0.1, width: 0.04)
            let pos = GLKVector3Make(0, myProps.size * 0.3, 0)
            self.addInElems("tige", type: "tigeShape", index: index, options: nil, props: tigeProps, position: pos, orientation: nil)
        }
    }
    
    override func generateZeroElemItemFromShadow(shadow: SYElementShadow, atIndex index: Int) -> (props: Any, position: GLKVector3?, orientation: GLKVector4?) {
        // let myProps = self.propsList[index] as! SYElementRootProps
        switch shadow.type {
        case "branchShape":
            return (SYGeomBranchProps(size: 0, width: 0, random: 0), nil, nil)
        case "leafShape":
            return (SYGeomLeafProps(size: 0, bend: 0.3), nil, nil)
        case "leafShape":
            return (SYGeomTigeProps(size: 0, bend: 0.3, width: 0), nil, nil)
        default:
            return (SYGeomBranchProps(size: 0, width: 0, random: 0), nil, nil)
        }
    }
    
    override func generateElemFromShadow(shadow: SYElementShadow) {
        switch shadow.type {
        case "branchShape":
            let branch = SYShapeBranch(propsList: shadow.allProps, positionsList: shadow.allPositions, orientationsList: shadow.allOrientations, randomManager: self.randomManager)
            self.elems.append(branch)
        case "leafShape":
            let leaf = SYShapeLeaf(propsList: shadow.allProps, positionsList: shadow.allPositions, orientationsList: shadow.allOrientations, randomManager: self.randomManager)
            self.elems.append(leaf)
        case "tigeShape":
            let tige = SYShapeTige(propsList: shadow.allProps, positionsList: shadow.allPositions, orientationsList: shadow.allOrientations, randomManager: self.randomManager)
            self.elems.append(tige)
        default:
            break
        }
    }
    
}

