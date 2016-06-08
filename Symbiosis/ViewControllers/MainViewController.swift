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
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
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
    
    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
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
        state.dispatchAction(SYStateActionType.HideOnboarding, payload: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func showNotifications(textNotification : String){
        print("showNotifications")
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
    
    func showComments() {
        // Trigger segue
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Comments")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // - MARK: Update
    
    func onStateSetup() {
        
        // Init tab bar display
        if state.tabBarIsDisplayed() {
            self.showTabBar(false)
        } else {
            self.hideTabBar(false)
        }
        
        if let onboarding = state.getOnboardingToDisplay() {
            state.dispatchAction(SYStateActionType.ShowOnboarding, payload: onboarding)
            let dataLoarder = SYDataLoader()
            let onboardingData = dataLoarder.loadJson("Onboarding", secondArray: onboarding, name:"name")
            self.showOnboarding(onboardingData)
        }
        
        if state.commentIsDisplay() {
            showComments()
        }
        
        updateViewContainer(false)

    }
    
    func onStateUpdate() {
        
        if state.tabHasChanged() {
            updateViewContainer(true)
        }
        
        if state.hasNotifToSend() {
            state.dispatchAction(SYStateActionType.NotificationSended, payload: nil)
            self.showNotifications("Youpi ! J’ai une surprise pour toi !")
        }
        
        if state.commentDisplayHasChanged() {
            if state.commentIsDisplay() {
                showComments()
            }
        }
        
        if state.tabBarDisplayHasChanged() {
            if state.tabBarIsDisplayed() {
                self.showTabBar(true)
            } else {
                self.hideTabBar(true)
            }
        }
        
//        if state.userIsAuthenticated() == false {
//            //LOGIN
//             showLogin()
//        }
        
        if let onboarding = state.getOnboardingToDisplay() {
            state.dispatchAction(SYStateActionType.ShowOnboarding, payload: onboarding)
            let dataLoarder = SYDataLoader()
            let onboardingData = dataLoarder.loadJson("Onboarding", secondArray: onboarding, name:"name")
            self.showOnboarding(onboardingData)
        }
        
        if state.backgroundModeHasChanged() {
            print("Background \(state.isInBackgroundMode())")
            if state.isInBackgroundMode() {
                print("Start background")
                backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
                    [unowned self] in
                    self.endBackgroundTask()
                }
            }
        }
        
        switch UIApplication.sharedApplication().applicationState {
        case .Active:
            break
        case .Background:
            break
            // NSLog("Background time remaining = %.1f seconds", UIApplication.sharedApplication().backgroundTimeRemaining)
        case .Inactive:
            break
        }
    }
    
    func updateViewContainer(animated: Bool) {
        let currentTab = state.getCurrentTab()
        let previousTab = state.getPreviousTab()
        
        if mountedViewCtrl != nil {
            mountedViewCtrl.willMoveToParentViewController(nil)
        }
        
        var direction: CGFloat = currentTab < previousTab ? -1 : 1
        if animated == false {
            direction = 0
        }
        
        let currentViewCtrl = getViewControllerForIndex(currentTab)
        
        self.addChildViewController(currentViewCtrl)
        self.containerView.addSubview(currentViewCtrl.view)
        
        // Add new constraints
        currentViewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        
        let subView = currentViewCtrl.view
        let parentView = containerView
        let constWidth = NSLayoutConstraint.init(item: subView, attribute: .Width, relatedBy: .Equal, toItem: parentView, attribute: .Width, multiplier: 1, constant: 0)
        constWidth.active = true
        let constHeight = NSLayoutConstraint.init(item: subView, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: 1, constant: 0)
        constHeight.active = true
        let constLeft = NSLayoutConstraint.init(item: subView, attribute: .Left, relatedBy: .Equal, toItem: parentView, attribute: .Left, multiplier: 1, constant: (parentView.frame.width * direction))
        constLeft.active = true
        let constTop = NSLayoutConstraint.init(item: subView, attribute: .Top, relatedBy: .Equal, toItem: parentView, attribute: .Top, multiplier: 1, constant: 0)
        constTop.active = true
        
        // Animate
        let animatedViewCtrl = currentViewCtrl
        let viewCtrlToRemove = mountedViewCtrl
        if animated == false {
            animatedViewCtrl.view.alpha = 0
        }
        containerView.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: {
            animatedViewCtrl.view.alpha = 1
            constLeft.constant = 0
            animatedViewCtrl.view.layoutIfNeeded()
            }, completion: { finished in
                if finished == false {
                    animatedViewCtrl.view.alpha = 1
                    constLeft.constant = 0
                    animatedViewCtrl.view.layoutIfNeeded()
                }
                if viewCtrlToRemove != nil {
                    viewCtrlToRemove.view.removeFromSuperview()
                    viewCtrlToRemove.removeFromParentViewController()
                }
                animatedViewCtrl.didMoveToParentViewController(self)
        })
        
        mountedViewCtrl = currentViewCtrl
        
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