//
//  SYGeomEmpty.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

/**
 * Empty
 **/
struct SYGeomEmptyProps {}

class SYGeomEmpty: SYGeom {
    
    override func verifyProps() {
        if !(self.props is SYGeomEmptyProps) {
            fatalError("Incorrect Props")
        }
    }
    
    override func boneFunc (options: SYBoneFuncOptions) -> SYBone {
        let translation: GLKVector3 = GLKVector3Make(0, 0, 0)
        let orientation: GLKMatrix4 = GLKMatrix4MakeRotation(0.1, 0, 0, 1)
        return SYBone(translation: translation, orientation: orientation, isLastStep: true)
    }
    
    override func stepFunc (options: SYStepFuncOptions) -> SYStep {
        return SYStep(points: [])
    }
    
    override func generateMaterial() {
        self.materials = []
    }
    
}


