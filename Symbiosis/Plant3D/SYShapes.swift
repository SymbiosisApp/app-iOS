//
//  SYShapes.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 19/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

class SYShapeLeaf: SYShape {
    
    override func createGeoms() {
        for props in propsList {
            let newProps = props as! SYGeomLeafProps
            self.geoms.append(SYGeomLeaf(props: newProps)  )
        }
    }
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomLeafProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
}

class SYShapeBranch: SYShape {
    
    override func createGeoms() {
        for props in propsList {
            let newProps = props as! SYGeomBranchProps
            self.geoms.append(SYGeomBranch(props: newProps)  )
        }
    }
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomBranchProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
}

class SYShapeTrunk: SYShape {
    
    override func createGeoms() {
        for props in propsList {
            let newProps = props as! SYGeomTrunkProps
            self.geoms.append(SYGeomTrunk(props: newProps)  )
        }
    }
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYGeomTrunkProps) {
                fatalError("Incorect Props")
            }
        }
    }
    
}