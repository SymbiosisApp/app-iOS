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
            
            
            
//            self.addInElems("brick", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: nil)
//            
//            let val: Float = 20
//            
//            self.addInElems("brick--1", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 0)))
//            self.addInElems("brick--2", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 2)))
//            self.addInElems("brick--3", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 4)))
//            self.addInElems("brick--4", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 6)))
//            self.addInElems("brick--5", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 8)))
//            self.addInElems("brick--6", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 10)))
//            self.addInElems("brick--7", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, val, 0, 12)))
//            
//            
            
            
            for i in 0..<6 {
                let leafProps = SYGeomLeafProps(size: myProps.size * 0.9 )
                let angle = Float(i) * (Float(M_PI) / 6)
                var orient = GLKVector4Make(0, 0, 1, 0)
                let rotate = GLKMatrix4MakeYRotation(angle)
                orient = GLKVector4Normalize(GLKMatrix4MultiplyVector4(rotate, orient))

                self.addInElems("leaf-\(i)", type: "leafShape", propsIndex: propsIndex, options: myProps.rootProps, props: leafProps, position: nil, orientation: GLKVector4Normalize(GLKVector4Make(0, 1, 0, angle)))
                
                // self.addInElems("brick-\(i)", type: "brickShape", propsIndex: propsIndex, options: myProps.rootProps, props: SYGeomBrickProps(size: 1), position: nil, orientation: GLKVector4Make(0, 1, 0, angle))
                
                
            }
            
        }
    }
    
}

