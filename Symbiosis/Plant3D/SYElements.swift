//
//  SYElements.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 24/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit
import GLKit


struct SYElementRootProps {
    var size: Float = 1
}

class SYElementRoot: SYElement {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYElementRootProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateElemsList() {
        let plantType = self.randomManager.get("plantRootType") % 1
        for props in propsList {
            let myProps = props as! SYElementRootProps
            switch plantType {
            case 0:
                // Branch
                let size = myProps.size
                let props = SYElementBranchProps(id: "rootBranch", size: size)
                self.addInElems("branch", type: "branchElem", props: props, position: nil, orientation: nil)
            default:
                print("Whaaaat ?")
            }
        }
        
    }
    
    override func generateElemFromShadow(shadow: SYElementShadow) {
        switch shadow.type {
        case "branchElem":
            let branch = SYElementBranch(propsList: shadow.props, positionsList: shadow.positions, orientationsList: shadow.orientations, randomManager: self.randomManager)
            self.elems.append(branch)
        default:
            break
        }
    }
    
}




struct SYElementBranchProps {
    let id: String;
    var size: Float = 1;
}

class SYElementBranch: SYElement {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYElementBranchProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateElemsList() {
        var maxNumberOfElems: Int = 0
        for props in propsList {
            let myProps = props as! SYElementBranchProps
            let numberOfElems = Int((1 + myProps.size) * (1 + myProps.size))
            maxNumberOfElems = max(numberOfElems, maxNumberOfElems)
        }
        for props in propsList {
            let myProps = props as! SYElementBranchProps
            let numberOfElems = Int((1 + myProps.size) * (1 + myProps.size))
            for i in 1...maxNumberOfElems {
                let subId = myProps.id + "-branch" + String(i)
                let branchRandom = randomManager.get(subId);
                let branchMult = UtilsRandom(withRandom: branchRandom, between: 0.5, and: 1.2)
                
                var size = myProps.size * branchMult;
                let width: Float = 0.08 + size * 0.01
                
                if i >= numberOfElems {
                    size = 0
                }
                
                let childProps = SYGeomBranchProps(size: size, width: width, random: branchRandom)
                let name = "subBranch-\(i)"
                self.addInElems(name, type: "branchShape", props: childProps, position: nil, orientation: nil)
            }
        }
    }
    
    override func generateElemFromShadow(shadow: SYElementShadow) {
        switch shadow.type {
        case "branchShape":
            let branch = SYShapeBranch(propsList: shadow.props, positionsList: shadow.positions, orientationsList: shadow.orientations, randomManager: self.randomManager)
            self.elems.append(branch)
        default:
            break
        }
    }
    
}


