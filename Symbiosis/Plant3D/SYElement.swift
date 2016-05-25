//
//  SYElement.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 29/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit
import GLKit

class SYElementShadow {
    var name: String;
    var positions: [GLKVector3] = [];
    var orientations: [GLKVector4] = [];
    var props: [Any] = []
    
    init(name: String) {
        self.name = name
    }
}

struct SYElemEmptyProps {}

/**
 * This class put SYShapes and other SYElements together :)
 **/
class SYElement: SCNNode, SYRederable {
    
    var propsList: [Any]
    var positionsList: [GLKVector3]
    var orientationsList: [GLKVector4]
    
    var shadows: [SYElementShadow] = []
    var elems: [SYRederable] = []
    
    init(propsList: [Any], positionsList: [GLKVector3], orientationsList: [GLKVector4]) {
        if propsList.count == 0 {
            fatalError("At least on props")
        }
        self.positionsList = positionsList
        self.orientationsList = orientationsList
        self.propsList = propsList
        super.init()
        self.verifyProps()
        self.generateElemsList()
        if self.verifyElemsList() {
            self.generateAllElemsFromShadows()
            self.addAllElemsAsChildNodes()
        } else {
            print("ShadowElems are not valid !")
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findShadowWithName(name: String) -> SYElementShadow {
        for shadow in shadows {
            if shadow.name == name {
                return shadow;
            }
        }
        let shadow = SYElementShadow(name: name)
        self.shadows.append(shadow)
        return shadow;
    }
    
    private func generateAllElemsFromShadows() {
        for shadow in shadows {
            self.generateElemFromShadow(shadow)
        }
    }
    
    private func addAllElemsAsChildNodes() {
        for elem in elems {
            let elemNode = elem as! SCNNode
            self.addChildNode(elemNode)
        }
    }
    
    private func verifyElemsList() -> Bool {
        let propsSize = propsList.count
        for elem in shadows {
            if elem.orientations.count != propsSize {
                return false
            }
            if elem.positions.count != propsSize {
                return false
            }
        }
        return true;
    }
    
    func addInElems(elemName: String, props: Any, position: GLKVector3?, orientation: GLKVector4? ) {
        let shadow = self.findShadowWithName(elemName)
        shadow.props.append(props)
        if position == nil {
            shadow.positions.append(GLKVector3Make(0, 0, 0))
        } else {
            shadow.positions.append(position!)
        }
        if orientation == nil {
            shadow.orientations.append(GLKVector4Make(0, 1, 0, 0))
        } else {
            shadow.orientations.append(orientation!)
        }
    }
    
    func render(progress: Float) {
        // Render positions
        if self.propsList.count > 1 {
            // Interpolate pos and orient
            let pos = GLKVector3Lerp(self.positionsList[0], self.positionsList[1], progress)
            self.position = SCNVector3FromGLKVector3(pos)
            let orien = GLKVector4Lerp(self.orientationsList[0], self.orientationsList[1], progress)
            self.orientation = SCNVector4FromGLKVector4(orien)
        } else {
            // Single props render
            self.position = SCNVector3FromGLKVector3(self.positionsList[0])
            self.orientation = SCNVector4FromGLKVector4(self.orientationsList[0])
        }
        
        // render children
        for elem in elems {
            elem.render(progress)
        }
    }
    
    // Overide to verify the type of props
    func verifyProps() {}
    
    // Override to generate elems list from propsList
    func generateElemsList() {
        // Exemple
        for props in propsList {
            // use self.addInElems to generate elems
            let newProps = props as! SYElemEmptyProps
            self.addInElems("yolo", props: newProps, position: nil, orientation: nil)
        }
    }

    // Overide this to convert a SYElemShadow to a SYElem or a SYShape
    // then append them to self.elems
    func generateElemFromShadow(shadow: SYElementShadow) {}
    
}