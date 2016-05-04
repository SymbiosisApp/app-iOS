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

        let startTime = CFAbsoluteTimeGetCurrent()
        
        let elem = SYElementBranch()
        scene.rootNode.addChildNode(elem)
        
        // Async task
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            elem.render(1.0)
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Render time : \(timeElapsed)")

        let cameraTarget = SCNNode()
        cameraTarget.position = SCNVector3Make(0, 0.5, 0)
        scene.rootNode.addChildNode(cameraTarget)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.xFov = 30.0
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.position = SCNVector3(x: 5, y: 1, z: 5)
        let constraint = SCNLookAtConstraint(target: cameraTarget)
        constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3Make(2, 3, 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add a light to the scene
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode2.position = SCNVector3Make(2, 2, 2);
        scene.rootNode.addChildNode(lightNode2)
        
        
        // Add froor
        let floorMat = SCNMaterial()
        floorMat.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        floorMat.doubleSided = true
        floorMat.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let myFloor = SCNFloor()
        myFloor.materials = [floorMat]
        myFloor.reflectivity = 0;
        let myFloorNode = SCNNode(geometry: myFloor)
        myFloorNode.position = SCNVector3Make(0, 0, 0);
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
