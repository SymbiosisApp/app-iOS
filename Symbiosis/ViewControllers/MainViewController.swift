//
//  MainViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, SYStateListener {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBar: SYTabBar!
    @IBOutlet weak var popup: SYPopup!
    
    
    // @IBOutlet weak var tabBatBottomConst: NSLayoutConstraint!
    
    var tabBarShowConst: NSLayoutConstraint!
    var tabBarHiddentConst: NSLayoutConstraint!
    
    // For tabs (ViewControllers names)
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Settings"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]
    weak var mountedViewCtrl: UIViewController!
    
    var isLoaded: Bool = false
    
    // State
    let state = SYStateManager.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabBatBottomConst.active = false;

        self.tabBarHiddentConst = NSLayoutConstraint.init(item: self.tabBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.tabBarHiddentConst.identifier = "tabBarHiddentConst"
        self.tabBarShowConst = NSLayoutConstraint.init(item: self.tabBar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.tabBarShowConst.identifier = "tabBarShowConst"
        
        tabBarShowConst.active = true;
        
        self.view.layoutIfNeeded();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.isLoaded == false {
            // Listen to events
            state.addListener(self)
            
            self.isLoaded = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.applyStyle()
    }
    
    func showLogin(){
        dispatch_async(dispatch_get_main_queue(), {
            let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let vc :UIViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
            let navigationController = UINavigationController(rootViewController: vc)
            self.presentViewController(navigationController, animated: true, completion: nil)
        })
        
    }
    
    func showOnboarding(onboardingData:NSDictionary)   {
        let viewController: UIViewController = OnboardingViewController(data: onboardingData as! [String : AnyObject])
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func closeOnboarding(segue: UIStoryboardSegue)    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func showNotifications(textNotification : String){
        let now = NSDate(timeIntervalSinceNow: 10)
        let notification = UILocalNotification()
        notification.alertBody = textNotification
        notification.fireDate = now
        //notification.soundName =
        //notification.alertAction =
        //notification.category =
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func getViewControllerForIndex(tabIndex: Int) -> UIViewController {
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
        return tabView
    }

    
    func setTabNavigation() {
        
        
//        if tabViews[tabIndex] == nil {
//            let tabName = viewsNames[tabIndex]
//            if tabStoryboards[tabIndex] == nil {
//                tabStoryboards[tabIndex] = UIStoryboard(name: tabName, bundle: nil)
//            }
//            let strboard = tabStoryboards[tabIndex]!
//            
//            tabViews[tabIndex] = strboard.instantiateViewControllerWithIdentifier("\(tabName)ViewCtrl")
//            tabViews[tabIndex]!.view.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        let tabView = tabViews[tabIndex]!
//        
//        if currentTabView == nil {
//            // just set up
//            self.addChildViewController(tabView)
//            self.addSubview(tabView.view, toView: self.containerView)
//            self.containerView.layoutIfNeeded()
//            self.containerView.layoutSubviews()
//        } else {
//            // Animate transition
//            let invertDirection = tabIndex < state.getPreviousTab()
//            self.cycleFromViewController(self.currentTabView!, toViewController: tabView, inverseDirection: invertDirection)
//        }
//        self.currentTabView = tabView
        
    }
    
    func hideTabBar(animated: Bool) {
        var duration = 0.3
        if animated == false {
            duration = 0
        }
        UIView.animateWithDuration(duration, animations: {
            self.tabBarShowConst.active = false;
            self.tabBarHiddentConst.active = true;
            self.tabBar.alpha = 0;
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            }, completion: { (completed) in
                self.tabBar.hidden = true
                if completed == false {
                    self.tabBar.alpha = 0;
                }
        })
    }
    
    func showTabBar(animated: Bool) {
        var duration = 0.3
        if animated == false {
            duration = 0
        }
        self.tabBar.hidden = false
        UIView.animateWithDuration(duration, animations: {
            self.tabBarHiddentConst.active = false;
            self.tabBarShowConst.active = true;
            self.tabBar.alpha = 1;
            self.view.layoutIfNeeded()
            self.tabBar.applyStyle()
            }, completion: { (completed) in
                self.tabBar.applyStyle()
                if completed == false {
                    self.tabBar.alpha = 1;
                }
        })
    }
    
    // - MARK: Update
    
    func onStateSetup() {
        
        // Init tab bar display
        if state.tabBarIsHidden() {
            self.hideTabBar(false)
        } else {
            self.showTabBar(false)
        }
        
        updateViewContainer(false)

    }
    
    func onStateUpdate() {
        
        if state.tabHasChanged() {
            updateViewContainer(true)
        }
        
        if state.tabBarHiddenHasChanged() {
            if state.tabBarIsHidden() {
                self.hideTabBar(true)
            } else {
                self.showTabBar(true)
            }
        }
        
//        self.didReceiveMemoryWarning()
//        self.didReceiveMemoryWarning()
//        self.didReceiveMemoryWarning()
        
        if false /* TODO : state.needLogin ? */ {
            //LOGIN
            let user = UserSingleton.sharedInstance;
            if(user.getUserData()["userId"] == nil){
                //showLogin()
            }
        }
        
        if false /* TODO : state.getNotification ? */ {
            //call notification with texte
            showNotifications("texte yolo notif")
        }
        
        if let onboarding = state.getOnboardingToDisplay() {
            state.dispatchAction(SYStateActionType.ShowOnboarding, payload: onboarding)
            let dataLoarder = SYDataLoader()
            let onboardingData = dataLoarder.loadJson("Onboarding", secondArray: onboarding, name:"name")
            self.showOnboarding(onboardingData)
        }
    }
    
    func updateViewContainer(animated: Bool) {
        let currentTab = state.getCurrentTab()
        let previousTab = state.getPreviousTab()
        
        if mountedViewCtrl != nil {
            mountedViewCtrl.willMoveToParentViewController(nil)
        }
        
        let currentViewCtrl = getViewControllerForIndex(currentTab)
        
        self.addChildViewController(currentViewCtrl)
        self.containerView.addSubview(currentViewCtrl.view)
        
        // Add new constraints
        currentViewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        
        let subView = currentViewCtrl.view
        let parentView = containerView
        let constTop = NSLayoutConstraint.init(item: subView, attribute: .Top, relatedBy: .Equal, toItem: parentView, attribute: .Top, multiplier: 1, constant: 0)
        constTop.active = true
        let constBottom = NSLayoutConstraint.init(item: subView, attribute: .Bottom, relatedBy: .Equal, toItem: parentView, attribute: .Bottom, multiplier: 1, constant: 0)
        constBottom.active = true
        let constLeading = NSLayoutConstraint.init(item: subView, attribute: .Leading, relatedBy: .Equal, toItem: parentView, attribute: .Leading, multiplier: 1, constant: 0)
        constLeading.active = true
        let constTrailing = NSLayoutConstraint.init(item: subView, attribute: .Trailing, relatedBy: .Equal, toItem: parentView, attribute: .Trailing, multiplier: 1, constant: 0)
        constTrailing.active = true
        
        containerView.layoutIfNeeded()
        containerView.layoutSubviews()
        
        if mountedViewCtrl != nil {
            mountedViewCtrl.view.removeFromSuperview()
            mountedViewCtrl.removeFromParentViewController()
        }
        currentViewCtrl.didMoveToParentViewController(self)
        
        mountedViewCtrl = currentViewCtrl
        
//        UIView.animateWithDuration(0.3, animations: {
//            newViewController.view.alpha = 1
//            leftConstraint.constant = 0
//            newViewController.view.layoutIfNeeded()
//            },
//                                   completion: { finished in
//                                    if finished == false {
//                                        newViewController.view.alpha = 1
//                                        leftConstraint.constant = 0
//                                        newViewController.view.layoutIfNeeded()
//                                    }
//                                    oldViewController.view.removeFromSuperview()
//                                    oldViewController.removeFromParentViewController()
//                                    newViewController.didMoveToParentViewController(self)
//        })
        
    }
    
    // - MARK: Utils
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        subView.removeConstraints(subView.constraints)
        
        // subView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        parentView.layoutIfNeeded()
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController, inverseDirection: Bool) {
        
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.containerView!.addSubview(newViewController.view)
        
        let directionMultiplier: Float = inverseDirection ? -1.0 : 1.0
        
        // Add new constraints
        
        // newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = newViewController.view
        self.containerView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: .Left, relatedBy: .Equal, toItem: self.containerView!, attribute: .Left, multiplier: 1.0, constant: 100 * CGFloat(directionMultiplier));
        leftConstraint.active = true
        let widthConstraint = NSLayoutConstraint.init(item: newViewController.view, attribute: .Width, relatedBy: .Equal, toItem: self.containerView!, attribute: .Width, multiplier: 1.0, constant: 0 );
//         100 * CGFloat(directionMultiplier)
        widthConstraint.active = true;
        
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.3, animations: {
                newViewController.view.alpha = 1
                leftConstraint.constant = 0
                newViewController.view.layoutIfNeeded()
            },
            completion: { finished in
                if finished == false {
                    newViewController.view.alpha = 1
                    leftConstraint.constant = 0
                    newViewController.view.layoutIfNeeded()
                }
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
    
    
    
    // - MARK: Memory warning
    override func didReceiveMemoryWarning() {
        print("Memory Warning !!!!")
        var hasReleaseSomething = false
        for (index, view) in tabViews.enumerate() {
            if index != state.getCurrentTab() && view != nil && hasReleaseSomething == false {
                tabViews[index] = nil
                hasReleaseSomething = true
            }
        }
        if hasReleaseSomething == false {
            for (index, strboard) in tabStoryboards.enumerate() {
                if index != state.getCurrentTab() && strboard != nil && hasReleaseSomething == false {
                    tabStoryboards[index] = nil
                    hasReleaseSomething = true
                }
            }
        }
    }
}