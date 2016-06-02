//
//  SYElementRoot.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit


struct SYElementRootProps {
    let size: Float;
    let hasLeefs: Bool;
    let nbrOfFlower: Int;
    let nbrOfFruits: Int;
    let nbrOfSeed: Int;
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
        let plantType = self.getRandomManager().get("plantRootType") % 1
        for (propsIndex, props) in propsList.enumerate() {
            let rootProps = props as! SYElementRootProps
            switch plantType {
            case 0:
                // Branch
                let props = SYElementBasicType1Props(id: "rootBranch", rootProps: rootProps)
                self.addInElems("root", type: "basicType1", propsIndex: propsIndex, options: nil, props: props, position: nil, orientation: nil)
            default:
                fatalError("Whaaaat ?")
            }
        }
        
    }
    
    override func generateZeroElemItemFromShadow(shadow: SYElementShadow, atIndex index: Int) -> (props: Any, position: GLKVector3?, orientation: GLKVector4?) {
        let rootProps = self.propsList[index] as! SYElementRootProps
        switch shadow.type {
        case "basicType1":
            return (SYElementBasicType1Props(id: "rootBranch", rootProps: rootProps), nil, nil)
        default:
            return (SYElementBasicType1Props(id: "rootBranch", rootProps: rootProps), nil, nil)
        }
    }
    
    override func generateElemFromShadow(shadow: SYElementShadow) {
        switch shadow.type {
        case "basicType1":
            let branch = SYElementBasicType1(propsList: shadow.allProps, positionsList: shadow.allPositions, orientationsList: shadow.allOrientations, parent: self)
            self.elems.append(branch)
        default:
            break
        }
    }
    
}

