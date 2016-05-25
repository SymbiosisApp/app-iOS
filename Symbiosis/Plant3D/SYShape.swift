//
//  SYShape.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 19/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit

/**
 * This class manage the SCNMorpher, need subclasses for correct Props type
 **/
class SYShape: SCNNode, SYRederable {
    
    var geoms: [SYGeom] = []
    
    var propsList: [Any]
    var positionsList: [GLKVector3]
    var orientationsList: [GLKVector4]
    
    init(propsList: [Any], positionsList: [GLKVector3], orientationsList: [GLKVector4]) {
        if propsList.count == 0 {
            fatalError("At least on props")
        }
        self.positionsList = positionsList
        self.orientationsList = orientationsList
        self.propsList = propsList
        super.init()
        self.verifyProps()
        self.generateAllGeomStructure()
        if propsList.count > 1 {
            self.resolveAllGeomStructure()
        }
        self.generateAllGeomData()
        self.createMorpher()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateAllGeomStructure() {
        for props in propsList {
            let newProps = props as! SYGeomEmptyProps
            self.geoms.append(SYGeomEmpty(props: newProps)  )
        }
    }
    
    func verifyProps() {}
    
    func render(progress: Float) {
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
        self.morpher?.setWeight(CGFloat(progress), forTargetAtIndex: 0)
    }
    
    private func createMorpher() {
        self.geometry = geoms[0].geometry
        self.morpher = SCNMorpher()
        for i in 1..<geoms.count {
            self.morpher?.targets.append(geoms[i].geometry!)
        }
    }
    
    private func generateAllGeomData() {
        for geom in geoms {
            geom.generateGeometry()
        }
    }
    
    private func resolveAllGeomStructure () {
        var steps: [[SYStep]] = []
        for geo in geoms {
            steps.append(geo.steps)
        }
        
        var numberOfSteps: Int = 0
        for step in steps {
            numberOfSteps = max(numberOfSteps, step.count)
        }
        
        print(numberOfSteps)
        
        for i in 0..<numberOfSteps {
            // Add step if needed
            print(i)
            for (index, step) in steps.enumerate() {
                if step.count <= i {
                    if i > 1 {
                        let lastStepFirstPoint = step[i-1].points[0]
                        steps[index].append(SYStep(points: [lastStepFirstPoint]))
                    } else {
                        steps[index].append(SYStep(points: [GLKVector3Make(0, 0, 0)]))
                    }
                }
            }
            var numberOfPoints = 0
            for step in steps {
                numberOfPoints = max(numberOfPoints, step[i].count)
            }
            // Add points if need
            for j in 0..<numberOfPoints {
                for (index, step) in steps.enumerate() {
                    if step[i].count <= j {
                        // Add first point at the end
                        steps[index][i].points.append(step[i].points[0])
                    }
                }
            }
            
            for index in 0..<geoms.count {
                geoms[index].steps = steps[index]
            }
        }
        
        // Verify
        var keys: [String] = []
        for step in steps {
            var stepKey = "["
            for hey in step {
                stepKey += String(hey.count) + ","
            }
            stepKey += "]"
            keys.append(stepKey)
        }
        for i in 1..<keys.count {
            if keys[i] != keys[i-1] {
                print("Not same structure !")
                print(keys[i-1])
                print(keys[i])
            } else {
                print("Same Structure !")
            }
        }
    }
    
    
}