//
//  MainViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBar: SYTabBar!
    
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Help"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]
    
    weak var currentTabView: UIViewController?
    
    let state = SYStateManager.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
//        tabBar.delegate = self
        
        state.listenTo(.TabChanged, action: self.onTabChanged)
        
        // Init the tabBar on plant
        // tabBar.selectItem(2)

        state.selectTab(2)
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.applyStyle()
    }

    
    func setTabNavigation(tabIndex: Int) {
        if tabViews[tabIndex] == nil {
            let tabName = viewsNames[tabIndex]
            if tabStoryboards[tabIndex] == nil {
                tabStoryboards[tabIndex] = UIStoryboard(name: tabName, bundle: nil)
            }
            let strboard = tabStoryboards[tabIndex]!
            
            tabViews[tabIndex] = strboard.instantiateViewControllerWithIdentifier("\(tabName)ViewCtrl")
            tabViews[tabIndex]!.view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tabView = tabViews[tabIndex]!
        
        if currentTabView == nil {
            // just set up
            self.addChildViewController(tabView)
            self.addSubview(tabView.view, toView: self.containerView)
        } else {
            // Animate transition
            let invertDirection = tabIndex < state.lastSelectedTab
            self.cycleFromViewController(self.currentTabView!, toViewController: tabView, inverseDirection: invertDirection)
        }
        self.currentTabView = tabView
        
    }
    
    // - MARK: Events listener
    
    func onTabChanged() {
        if state.selectedTab < viewsNames.count {
            setTabNavigation(state.selectedTab)
        }
    }
    
    // - MARK: Utils
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController, inverseDirection: Bool) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.containerView!.addSubview(newViewController.view)
        
        print(inverseDirection)
        
        let directionMultiplier: Float = inverseDirection ? -1.0 : 1.0
        
        // new
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = newViewController.view
        self.containerView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        let leftConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView!, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
        leftConstraint.active = true
        let widthConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView!, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        widthConstraint.active = true;
        leftConstraint.constant = 100 * CGFloat(directionMultiplier)
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
    
    override func didReceiveMemoryWarning() {
        var hasReleaseSomething = false
        for (index, view) in tabViews.enumerate() {
            if index != state.selectedTab && view != nil && hasReleaseSomething == false {
                tabViews[index] = nil
                hasReleaseSomething = true
            }
        }
        if hasReleaseSomething == false {
            for (index, strboard) in tabStoryboards.enumerate() {
                if index != state.selectedTab && strboard != nil && hasReleaseSomething == false {
                    tabStoryboards[index] = nil
                    hasReleaseSomething = true
                }
            }
        }
    }
    
}