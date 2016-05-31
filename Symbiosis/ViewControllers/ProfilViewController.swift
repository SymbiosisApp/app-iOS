//
//  ProfilViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 28/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController {
    
    override func viewDidLoad() {
        
        
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0.3, y: 0.2))
        path.addCurveToPoint(CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0.3, y: 0.1), controlPoint2: CGPoint(x: 0.2, y: 0))
        path.addCurveToPoint(CGPoint(x: -0.2, y: 0.2), controlPoint1: CGPoint(x: -0.1, y: 0), controlPoint2: CGPoint(x: -0.2, y: 0.1))
        path.addCurveToPoint(CGPoint(x: 0.2, y: 0.8), controlPoint1: CGPoint(x: -0.2, y: 0.5), controlPoint2: CGPoint(x: 0.2, y: 0.6))
        path.addCurveToPoint(CGPoint(x: 0, y: 1), controlPoint1: CGPoint(x: 0.2, y: 0.9), controlPoint2: CGPoint(x: 0.1, y: 1))
        
        let shape = CAShapeLayer()
        var affineTransform = CGAffineTransformMakeScale(100, 100)
        let transformedPath = CGPathCreateCopyByTransformingPath(path.CGPath, &affineTransform)
        shape.path = transformedPath
        shape.fillColor = nil
        shape.strokeColor = UIColor.blackColor().CGColor
        shape.position = CGPoint(x: 100, y: 100)
        self.view.layer.addSublayer(shape)
        
        
    }
    
}