//
//  SYElementFlower1.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import GLKit
import SceneKit


struct SYElementFlower1Props {
    let id: String
    let size: Float
    var rootProps: SYElementRootProps
}

class SYElementFlower1: SYElement {
    
    override func verifyProps() {
        for props in propsList {
            if !(props is SYElementFlower1Props) {
                print(props)
                fatalError("Incorect Props")
            }
        }
    }
    
    override func generateElemsList() {
        for (propsIndex, props) in propsList.enumerate() {
            let myProps = props as! SYElementFlower1Props
            
            let centerElemProps = SYGeomSphereProps(size: myProps.size);
            
            self.addInElems("center", type: "sphereShape", propsIndex: propsIndex, options: nil, props: centerElemProps, position: nil, orientation: nil)
            
            let centerBones = SYGeomSphere(withoutGenerateWithProps: centerElemProps, parent: self).getBones()
            let leafsY = centerBones[Int(centerBones.count / 2)].position.y
            let leafsPos = GLKVector3Make(0, leafsY, 0)
            
            for i in 0..<6 {
                let leafProps = SYGeomLeafProps(size: myProps.size * 0.9 )
                let angle = Float(i) * (Float(M_PI) / 6)
                var orient = GLKVector4Make(0, 0, 1, 0)
                var rotate = GLKMatrix4MakeRotation(angle, 0, 1, 0)
                rotate = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(0.5), rotate)
                orient = GLKMatrix4MultiplyVector4(rotate, orient)
                self.addInElems("leaf-\(i)", type: "leafShape", propsIndex: propsIndex, options: myProps.rootProps, props: leafProps, position: leafsPos, orientation: orient)
            }
            
        }
    }
    
}

