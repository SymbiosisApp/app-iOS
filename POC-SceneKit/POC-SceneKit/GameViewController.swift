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

        // create a new scene
        let scene = SCNScene()
        self.scnView = self.view as? SCNView
        self.scnView!.scene = scene
        self.scnView!.delegate = self
        
        // material
        
        let redMataterialBis = SCNMaterial()
        redMataterialBis.diffuse.contents = UIColor.blueColor()
        redMataterialBis.doubleSided = true
        

        let options1: [String:Any] = [
            "test": Float(1),
            "rotate": Float(0)
        ]
        let customGeo1 = SYShape(options: options1).geometry!
        customGeo1.materials = [redMataterialBis]
        
        let options2: [String:Any] = [
            "test": Float(1),
            "rotate": Float(1)
        ]
        let customGeo2 = SYShape(options: options2).geometry!
        
        let options3: [String:Any] = [
            "test": Float(1),
            "rotate": Float(2)
        ]
        let customGeo3 = SYShape(options: options3).geometry!
        
        let options4: [String:Any] = [
            "test": Float(1),
            "rotate": Float(3)
        ]
        let customGeo4 = SYShape(options: options4).geometry!
        
        let cubeNodeBis = SCNNode(geometry:customGeo1)
        self.morpher = SCNMorpher()
        morpher!.targets = [customGeo1, customGeo2, customGeo3, customGeo4]
        cubeNodeBis.morpher = morpher
        
        let animation = CAAnimation()
        animation.usesSceneTimeBase = true
        
//        let animation = CABasicAnimation(keyPath: "morpher.weights[0]")
//        animation.fromValue = 0.0;
//        animation.toValue = 2.0;
//        animation.autoreverses = true;
//        animation.repeatCount = Float.infinity;
//        animation.duration = 1;
//        cubeNodeBis.addAnimation(animation, forKey: "morpher")

//        morpher.setWeight(1, forTargetAtIndex: 0)
        self.morpher!.setWeight(1, forTargetAtIndex: 1)
        
        scene.rootNode.addChildNode(cubeNodeBis)
        
        // Animate the 3d object
//        cubeNodeBis.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y:1, z:0, duration:1)))
//        

        
        




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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let deltaTime = time - self.lastUpdateTimeInterval
        self.lastUpdateTimeInterval = time
        
        self.updateMorpher(deltaTime)
    }
    
    func updateMorpher (deltaTime: NSTimeInterval) {
        self.animProgress += 1 * Float(deltaTime)
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
