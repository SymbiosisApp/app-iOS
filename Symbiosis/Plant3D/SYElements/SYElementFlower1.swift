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
            
            let centerElemProps = SYGeomSphereProps(size: myProps.size, orient: nil);
            
            self.addInElems("center", type: "sphereShape", propsIndex: propsIndex, options: nil, props: centerElemProps, position: nil, orientation: nil)
            
            let nbrOfLeafs: Int = 9
            let angleStep = Float(M_PI * 2) * (1 / Float(nbrOfLeafs))
            
            for i in 0..<nbrOfLeafs {
                let angle = Float(i) * angleStep
                let leafProps = SYGeomLeafProps(size: myProps.size * 0.9, firstRotation: GLKMatrix4MakeYRotation(angle), id: "\(myProps.id)-leaf-\(i)")
                var orient = GLKVector4Make(0, 0, 1, 0)
                let rotate = GLKMatrix4MakeYRotation(angle)
                orient = GLKVector4Normalize(GLKMatrix4MultiplyVector4(rotate, orient))

                self.addInElems("leaf-\(i)", type: "leafShape", propsIndex: propsIndex, options: myProps.rootProps, props: leafProps, position: nil, orientation: nil)
                
            }
            
        }
    }
    
}

