//
//  MainViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, SYTabBarDelegate {
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBar: SYTabBar!

    weak var currentViewController: UIViewController?
    var currentView: Int = 0;
    var testConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlantViewCtrl")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        
        tabBar.delegate = self
    }
    
    func onTabSelected(tabIndex: Int) {
        print("Yolo \(tabIndex)")
    }
    
    @IBAction func onTouchSwitchButton(sender: AnyObject) {
        if currentView == 0 {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewCtrl")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlantViewCtrl")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
        currentView = (currentView + 1) % 2
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.containerView!.addSubview(newViewController.view)
        
        // new
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = newViewController.view
        self.containerView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        let leftConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView!, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
        leftConstraint.active = true
        let widthConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView!, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        widthConstraint.active = true;
        
        print(oldViewController.view.constraints.count)

        leftConstraint.constant = 100
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.3, animations: {
                // only need to call layoutIfNeeded here
                newViewController.view.alpha = 1
                leftConstraint.constant = 0
                newViewController.view.layoutIfNeeded()
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
}