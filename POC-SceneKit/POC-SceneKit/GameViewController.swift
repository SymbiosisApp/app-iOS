//
//  GameViewController.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 15/02/2016.
//  Copyright (c) 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // create a new scene
        let scene = SCNScene()


        let nbrOfSteps = 10

        var stepOrigin = GLKVector3Make(0, 0, 0)
        var stepAngle = GLKMatrix4MakeRotation(0, 1, 0, 0)
        var stepsList = Array<Array<GLKVector3>>()
        var verticesList = [GLKVector3]()
        var indicesList = [Int]()
        var normalsList = [GLKVector3]()

        // Calculate Points
        for var step = 0; step <= nbrOfSteps; step++
        {

            // NSLog("%i / %i", step, nbrOfSteps)

            let progress = Float(step+1)/Float(nbrOfSteps)
            let width = Float(0.5 + (sin(Float(M_PI) * progress) * 1.0))
            let thickness = Float(0.1 + (sin(Float(M_PI) * progress) * 0.2))

            let point1 = SCNVector3Make(-thickness,0,0)
            let point2 = SCNVector3Make(width*0.4,0,width)
            let point3 = SCNVector3Make(thickness,0,0)
            let point4 = SCNVector3Make(width*0.4,0,-width)

            var step = [
                point1,
                point2,
                point3,
                point4
            ]

            let stepSize = step.count
            var stepRotated = [GLKVector3]()
            for var pointIndex = 0; pointIndex < stepSize; pointIndex++
            {
                var point = SCNVector3ToGLKVector3(step[pointIndex])
                point = GLKVector3Add(stepOrigin, GLKMatrix4MultiplyVector3WithTranslation(stepAngle, point))
                stepRotated.append(point)
            }
            
            stepsList.append(stepRotated)

            stepAngle = GLKMatrix4Multiply(stepAngle, GLKMatrix4MakeRotation(0.15, 0, 0, 1))
            let stepDiff = GLKMatrix4MultiplyVector3WithTranslation(stepAngle, GLKVector3Make(0, 0.5, 0))
            stepOrigin = GLKVector3Add(stepOrigin, stepDiff)

        }

        let stepSize = stepsList[0].count
        let stepListSize = stepsList.count

        // Create faces and normals
        for var stepIndex = 1; stepIndex < stepListSize; stepIndex++
        {
            for var pointIndex = 0; pointIndex < stepSize; pointIndex++
            {

                var nextPointIndex = pointIndex + 1
                if (nextPointIndex == stepSize) {
                    nextPointIndex = 0
                }

                // Get 4 points
                let point1 = stepsList[stepIndex][pointIndex]
                let point2 = stepsList[stepIndex][nextPointIndex]
                let point3 = stepsList[stepIndex-1][pointIndex]
                let point4 = stepsList[stepIndex-1][nextPointIndex]

                // Calculate normals
                let originPoint = GLKVector3Make(point1.x, point1.y, point1.z)
                let firstPoint = GLKVector3Make(point2.x, point2.y, point2.z)
                let secondPoint = GLKVector3Make(point3.x, point3.y, point3.z)
                let firstVector = GLKVector3Subtract(firstPoint, originPoint)
                let secondVector = GLKVector3Subtract(secondPoint, originPoint)
                var normal = GLKVector3CrossProduct(secondVector, firstVector)
                normal = GLKVector3Normalize(normal)

                // Add 4 time the same normal for each face
                normalsList += [
                    normal,
                    normal,
                    normal,
                    normal
                ]

                // Get Indexes
                let point1Index = verticesList.count
                let point2Index = point1Index + 1
                let point3Index = point1Index + 2
                let point4Index = point1Index + 3

                // Add Points
                verticesList += [point1, point2, point3, point4]

                // face one
                indicesList += [point1Index, point3Index, point4Index]

                // face two
                indicesList += [point1Index, point4Index, point2Index]

            }
        }
        
        // Print
        print(indicesList)
        for var index = 0; index < verticesList.count; index++
        {
            let vert = verticesList[index]
            print(vert.x, vert.y, vert.z)
        }

        let verticesCount = verticesList.count
        let normalsCount = normalsList.count
        let indicesCount = indicesList.count

        if (normalsCount != verticesCount) {
            print("normalsCount !== verticesCount : %i !== %i", normalsCount, verticesCount)
        }

        let positions :[SCNVector3] = verticesList.map { (vertice) -> SCNVector3 in
            return SCNVector3FromGLKVector3(vertice)
        }

        let normals :[SCNVector3] = normalsList.map { (norm) -> SCNVector3 in
            return SCNVector3FromGLKVector3(norm)
        }

        let indices :[CInt] = indicesList.map { (indi) -> CInt in
            return CInt(indi)
        }

        // Create sources for the vertices and normals
        let vertexSource = SCNGeometrySource(vertices:positions, count:verticesCount)
        let normalSource = SCNGeometrySource(normals:normals, count:normalsCount)

        let indexData = NSData(
            bytes:indices,
            length: (indices.count * sizeof(CInt))
        )

        let element = SCNGeometryElement(
            data:indexData,
            primitiveType:SCNGeometryPrimitiveType.Triangles,
            primitiveCount:indicesCount/3,
            bytesPerIndex: sizeof(CInt)
        )

        let geometry = SCNGeometry(
            sources:[vertexSource, normalSource],
            elements:[element]
        )


        // Red colored material

        let redMataterial = SCNMaterial()
        redMataterial.diffuse.contents = UIColor.redColor()
        redMataterial.doubleSided = true

        geometry.materials = [redMataterial]

        let cubeNode = SCNNode(geometry:geometry)
        scene.rootNode.addChildNode(cubeNode)

        // Animate the 3d object
        cubeNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y:1, z:0, duration:1)))














        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        let lightPosition = SCNVector3Make(3, 10, 10)
        
        // create and add a light to the scene
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode2.position = lightPosition;
        scene.rootNode.addChildNode(lightNode2)
        
        // Add froor
        let myFloor = SCNFloor()
        let myFloorNode = SCNNode(geometry: myFloor)
        myFloorNode.position = SCNVector3Make(0, -1, 0);
        scene.rootNode.addChildNode(myFloorNode)
        


        // retrieve the SCNView
        let scnView = self.view as! SCNView

        // set the scene to the view
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = UIColor.blackColor()

        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
    }

    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView

        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]

            // get its material
            let material = result.node!.geometry!.firstMaterial!

            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)

            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)

                material.emission.contents = UIColor.blackColor()

                SCNTransaction.commit()
            }

            material.emission.contents = UIColor.redColor()

            SCNTransaction.commit()
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
