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

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var animProgress: Float = 0
    var morpher: SCNMorpher?
    var scnView: SCNView?
    var lastUpdateTimeInterval: NSTimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let optionsTest: [String:Any] = [
//            "test": Float(1),
//            "rotate": Float(0)
//        ]
//        let customGeoTest = SYShape(options: optionsTest)
//        print(customGeoTest)

        // create a new scene
        let scene = SCNScene()
        self.scnView = self.view as? SCNView
        self.scnView!.scene = scene
        self.scnView!.delegate = self

        // material
//        let redMataterialBis = SCNMaterial()
//        redMataterialBis.diffuse.contents = UIColor.blueColor()
//        redMataterialBis.doubleSided = true
//        
//        let options1: [String:Any] = [:]
//        let customGeo1 = SYShape(options: options1).geometry!
//        customGeo1.materials = [redMataterialBis]
//        
//        let cubeNodeBis = SCNNode(geometry:customGeo1)
//        self.morpher = SCNMorpher()
//        morpher!.targets = [customGeo1, customGeo2, customGeo3, customGeo4]
//        cubeNodeBis.morpher = morpher
//
//        self.morpher!.setWeight(1, forTargetAtIndex: 1)
//      
        
        let leaf = SYShapeBranch(options: ["size": 1.0])
        scene.rootNode.addChildNode(leaf)
        leaf.render(1)
        leaf.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y:1, z:0, duration:1)))
        
//        let element = SYElement()
//        element.render(1.0)
        
//        scene.rootNode.addChildNode(element)
//        element.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y:1, z:0, duration:1)))
        
        // Animate the 3d object
//        cubeNodeBis.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y:1, z:0, duration:1)))
        
//        let animation = CAAnimation()
//        animation.usesSceneTimeBase = true

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
        
        // create and add a light to the scene
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light!.type = SCNLightTypeOmni
        lightNode3.position = SCNVector3Make(10, 3, -10);
        scene.rootNode.addChildNode(lightNode3)
        
        
        
        
//        // Add froor
        let floorMat = SCNMaterial()
        floorMat.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        floorMat.doubleSided = true
        floorMat.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let myFloor = SCNFloor()
        myFloor.materials = [floorMat]
        myFloor.reflectivity = 0;
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
//        let deltaTime = time - self.lastUpdateTimeInterval
//        self.lastUpdateTimeInterval = time
//        
//        self.updateMorpher(deltaTime)
    }
    
    func updateMorpher (deltaTime: Double) {
        self.animProgress += Float(deltaTime)
        print(self.animProgress)
        self.animProgress = self.animProgress % Float(self.morpher!.targets.count)
        let index = Int(floor(self.animProgress / 1.0))
        let nextIndex = (index + 1) % self.morpher!.targets.count
        let progress = CGFloat(self.animProgress - Float(index))
        for i in 0...self.morpher!.targets.count-1 {
            self.morpher!.setWeight(0, forTargetAtIndex: i)
        }
        self.morpher!.setWeight(1 - progress, forTargetAtIndex: index)
        self.morpher!.setWeight(progress, forTargetAtIndex: nextIndex)
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
