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


struct SYElementBranchProps {
    var size: Float = 1
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
        let branchRandom = 568655;
        for (index, props) in propsList.enumerate() {
            let myProps = props as! SYElementBranchProps
            
            let width: Float = 0.15 + myProps.size * 0.01
            let childProps = SYGeomBranchProps(size: myProps.size, width: width, random: branchRandom)
            
            var orien: GLKVector4? = nil;
            if index == 1 {
                orien = GLKVector4Make(1, 0, 0, 1)
            }
            
            self.addInElems("yolo", props: childProps, position: nil, orientation: orien)
        }
    }
    
    override func generateElemFromShadow(shadow: SYElementShadow) {
        switch shadow.name {
        case "yolo":
            let branch = SYShapeBranch(propsList: shadow.props, positionsList: shadow.positions, orientationsList: shadow.orientations)
            self.elems.append(branch)
        default:
            break
        }
    }

}


