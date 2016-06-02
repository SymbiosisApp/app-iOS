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
    
    // For tabs (ViewControllers names)
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Settings"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]
    weak var currentTabView: UIViewController?
    var pushPopup:Bool=false
    
    // State
    let state = SYStateManager.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Listen to events
        state.listenTo(.Update, action: self.onStateUpdate)
        
        // Init the tabBar on plant
        state.selectTab(2)
        
        //call notification with texte
//        showNotifications("texte yolo notif")
        
        //testing:
        //let dataLoarder = SYDataLoader()
        dispatch_async(dispatch_get_main_queue(), {
            //let onboardingData = dataLoarder.loadJson("Onboarding", secondArray: "Intro", name:"name")
            //self.showOnboarding(onboardingData)
        })
        
        //LOGIN
        let user = UserSingleton.sharedInstance;
        if(user.getUserData()["userId"] == nil){
            //showLogin()
        }
        
        //POPUP
        //sender = array popup + destination
        let popupData:NSDictionary = ["Map" : "commentaires"]
        self.performSegueWithIdentifier("popupSegue", sender: popupData)
        
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "popupSegue") {
            let secondViewController = segue.destinationViewController as! SYPopup
            
            let popupData = sender as! NSDictionary
            secondViewController.popupData = popupData
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
    
    func showOnboardingIntro() {
        //showonboarding et path onborading's name
        let dataLoarder = SYDataLoader()
        dispatch_async(dispatch_get_main_queue(), {
            let onboardingData = dataLoarder.loadJson("Onboarding", secondArray: "Intro", name:"name")
            self.showOnboarding(onboardingData)
        })
    }
    
    
    func showOnboarding(onboardingData:NSDictionary)   {
        let viewController: UIViewController = SYOnboarding(data: onboardingData as! [String : AnyObject])
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
            let invertDirection = tabIndex < state.getLastSelectedTab()
            self.cycleFromViewController(self.currentTabView!, toViewController: tabView, inverseDirection: invertDirection)
        }
        self.currentTabView = tabView
        
    }
    
    // - MARK: Update
    
    func onStateUpdate() {
        if state.tabHasChanged() {
            let currentTab = state.getSelectedTab()
            if currentTab < viewsNames.count {
                setTabNavigation(currentTab)
            }
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
        
        let directionMultiplier: Float = inverseDirection ? -1.0 : 1.0
        
        // Add new constraints
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
            if index != state.getSelectedTab() && view != nil && hasReleaseSomething == false {
                tabViews[index] = nil
                hasReleaseSomething = true
            }
        }
        if hasReleaseSomething == false {
            for (index, strboard) in tabStoryboards.enumerate() {
                if index != state.getSelectedTab() && strboard != nil && hasReleaseSomething == false {
                    tabStoryboards[index] = nil
                    hasReleaseSomething = true
                }
            }
        }
    }
}