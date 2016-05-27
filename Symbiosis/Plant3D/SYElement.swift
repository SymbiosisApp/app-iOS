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
    var type: String;
    var name: String;
    var options: Any? = nil;
    
    var positions: [GLKVector3?];
    var orientations: [GLKVector4?];
    var props: [Any?];
    
    var allProps: [Any] {
        get {
            var result: [Any] = []
            for prop in self.props {
                if prop != nil {
                    result.append(prop)
                }
            }
            return result
        }
    }
    
    var allPositions: [GLKVector3] {
        get {
            var result: [GLKVector3] = []
            for position in self.positions {
                if position != nil {
                    result.append(position!)
                }
            }
            return result
        }
    }
    
    var allOrientations: [GLKVector4] {
        get {
            var result: [GLKVector4] = []
            for orientation in self.orientations {
                if orientation != nil {
                    result.append(orientation!)
                }
            }
            return result
        }
    }
    
    init(type: String, name: String, options: Any?, size: Int) {
        print("init shadow with size \(size)")
        self.name = name
        self.type = type
        self.options = options
        positions = [GLKVector3?](count:size, repeatedValue: nil)
        orientations = [GLKVector4?](count:size, repeatedValue: nil)
        props = [Any?](count:size, repeatedValue: nil)
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
    
    let randomManager: SYRandomManager;
    
    var shadows: [SYElementShadow] = []
    var elems: [SYRederable] = []
    
    init(propsList: [Any], positionsList: [GLKVector3]?, orientationsList: [GLKVector4]?, randomManager: SYRandomManager) {
        self.randomManager = randomManager
        if propsList.count == 0 {
            fatalError("At least on props")
        }
        // Positions or basic positions
        if positionsList != nil {
            self.positionsList = positionsList!
        } else {
            self.positionsList = []
            for _ in 0..<propsList.count {
                self.positionsList.append(GLKVector3Make(0, 0, 0))
            }
        }
        // Orientation or basic orientation
        if orientationsList != nil {
            self.orientationsList = orientationsList!
        } else {
            self.orientationsList = []
            for _ in 0..<propsList.count {
                self.orientationsList.append(GLKVector4Make(0, 1, 0, 0))
            }
        }
        self.propsList = propsList
        super.init()
        self.verifyListsSizes()
        self.verifyProps()
        self.generateElemsList()
        self.resolveElemsList()
        self.verifyElemsList()
        self.generateAllElemsFromShadows()
        self.addAllElemsAsChildNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func verifyListsSizes() {
        let propsSize = self.propsList.count
        if self.positionsList.count != propsSize || self.orientationsList.count != propsSize {
            fatalError("Not as many positionsList or orientationsList as propsList !")
        }
    }
    
    private func findShadow(type: String, name: String, options: Any?) -> SYElementShadow {
        for shadow in shadows {
            if shadow.name == name && shadow.type == type {
                return shadow;
            }
        }
        let shadow = SYElementShadow(type: type, name: name, options: options, size: self.propsList.count)
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
    
    private func verifyElemsList() {
        let propsSize = propsList.count
        for elem in shadows {
            if elem.orientations.count != propsSize {
                fatalError("ShadowElems are not valid !")
            }
            if elem.positions.count != propsSize {
                print(self.shadows)
                fatalError("ShadowElems are not valid !")
            }
        }
    }
    
    // NOTE : options are only use the first time and are not replaced even if they are differents
    func addInElems(name: String, type: String, index: Int, options: Any?, props: Any, position: GLKVector3?, orientation: GLKVector4? ) {
        let shadow = self.findShadow(type, name: name, options: options)
        if index >= self.propsList.count {
            fatalError("Gné ? Index > propsList.count (\(self.propsList.count)) get \(index)")
        }
        shadow.props[index] = props
        if position == nil {
            shadow.positions[index] = GLKVector3Make(0, 0, 0)
        } else {
            shadow.positions[index] = position!
        }
        if orientation == nil {
            shadow.orientations[index] = GLKVector4Make(0, 1, 0, 0)
        } else {
            shadow.orientations[index] = orientation!
        }
    }
    
    func resolveElemsList() {
        for shadow in shadows {
            // props
            for (index, prop) in shadow.props.enumerate() {
                if prop == nil {
                    let emptyData = generateZeroElemItemFromShadow(shadow, atIndex: index)
                    self.addInElems(shadow.name, type: shadow.type, index: index, options: nil, props: emptyData.props, position: emptyData.position, orientation: emptyData.orientation)
                }
            }
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
            self.addInElems("yolo", type: "yoloType", index: 0, options: nil, props: newProps, position: nil, orientation: nil)
        }
    }

    // Overide this to convert a SYElemShadow to a SYElem or a SYShape
    // then append them to self.elems
    func generateElemFromShadow(shadow: SYElementShadow) {}
    
    // Overide to verify the type of props
    func generateZeroElemItemFromShadow(shadow: SYElementShadow, atIndex index: Int) -> (props: Any, position: GLKVector3?, orientation: GLKVector4?) {
        return (SYElemEmptyProps(), nil, nil)
    }
    
}