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
        let plantType = self.getRandomManager().get("plantRootType") % 1
        for (index, props) in propsList.enumerate() {
            let myProps = props as! SYElementRootProps
            switch plantType {
            case 0:
                // Branch
                let size = myProps.size
                let props = SYElementBasicType1Props(id: "rootBranch", size: size)
                self.addInElems("root", type: "basicType1", index: index, options: nil, props: props, position: nil, orientation: nil)
            default:
                fatalError("Whaaaat ?")
            }
        }
        
    }
    
    override func generateZeroElemItemFromShadow(shadow: SYElementShadow, atIndex index: Int) -> (props: Any, position: GLKVector3?, orientation: GLKVector4?) {
        // let myProps = self.propsList[index] as! SYElementRootProps
        switch shadow.type {
        case "basicType1":
            return (SYElementBasicType1Props(id: "rootBranch", size: 0), nil, nil)
        default:
            return (SYElementBasicType1Props(id: "rootBranch", size: 0), nil, nil)
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

