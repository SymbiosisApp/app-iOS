//
//  TabBar.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 13/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYTabBar: UIView, SYStateListener {
    
    // MARK: Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var plantButton: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    var notifs: [UIView] = []
    var centerConstraints: [NSLayoutConstraint] = []
    
    // MARK: Properties
//    var delegate: SYTabBarDelegate?
    var nibName: String = "TabBar"
    
    // MARK: State
    let state = SYStateManager.sharedInstance
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    func setup() {
        state.addListener(self)
        
        view = loadViewFromNib()
    
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // create Notifs
        for (index, button) in buttons.enumerate() {
            
            let notif = UIView()
            notifs.append(notif)
            button.addSubview(notif)
            // Width
            notif.addConstraint(NSLayoutConstraint.init(item: notif, attribute: .Width, relatedBy: .Equal, toItem: notif, attribute: .Height, multiplier: 1, constant: 0))
            // Height
            notif.addConstraint(NSLayoutConstraint.init(item: notif, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 10))
            // centerX
            button.addConstraint(NSLayoutConstraint.init(item: notif, attribute: .CenterX, relatedBy: .Equal, toItem: button, attribute: .CenterX, multiplier: 1, constant: 0))
            if index == 2 {
                let const = NSLayoutConstraint.init(item: notif, attribute: .CenterY, relatedBy: .Equal, toItem: plantButton, attribute: .Top, multiplier: 1, constant: 0)
                plantButton.addConstraint(const)
                self.centerConstraints.append(const)
            } else {
                let const = NSLayoutConstraint.init(item: notif, attribute: .CenterY, relatedBy: .Equal, toItem: background, attribute: .Top, multiplier: 1, constant: 0)
                background.addConstraint(const)
                self.centerConstraints.append(const)
            }
            
            button.layoutSubviews()
            
            notif.layer.backgroundColor = UIColor.redColor().CGColor
            notif.layer.cornerRadius = 5
            notif.translatesAutoresizingMaskIntoConstraints = false
            notif.hidden = true
        }
        
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    // This is called by the ViewController in viewDidLayoutSubviews
    func applyStyle() {
        
        // Background
        background.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.blackColor().CGColor
        background.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        background.layer.shadowOpacity = 0.1;
        background.layer.shadowRadius = 5
        let backShadowPath = UIBezierPath(rect: background.bounds)
        background.layer.shadowPath = backShadowPath.CGPath;
        
        plantButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        plantButton.layer.masksToBounds = false
        plantButton.layer.shadowColor = UIColor.blackColor().CGColor
        plantButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        plantButton.layer.shadowOpacity = 0.15;
        plantButton.layer.shadowRadius = 5
        plantButton.layer.cornerRadius = plantButton.layer.bounds.width/2
        let plantShadowPath = UIBezierPath(ovalInRect: plantButton.layer.bounds)
        plantButton.layer.shadowPath = plantShadowPath.CGPath;
    }
    
    func updateStyle() {
        for (index, button) in buttons.enumerate() {
            if state.isSelectedTab(index) {
                button.selected = true
            } else {
                button.selected = false
            }
        }
    }
    
    func updateNotifs() {
        for (index, _) in buttons.enumerate() {
            if state.tabNotificationHasChanged(index) {
                let notif = notifs[index]
                let const = centerConstraints[index]
                if state.isNotifiedTab(index) {
                    // Show
                    notif.hidden = false
                    notif.alpha = 0
                    const.constant = -20
                    self.view.layoutIfNeeded()
                    UIView.animateWithDuration(0.2, animations: {
                        notif.alpha = 1
                        const.constant = 0
                        self.view.layoutIfNeeded()
                    })
                } else {
                    // Hide
                    notif.alpha = 1
                    const.constant = 0
                    self.view.layoutIfNeeded()
                    UIView.animateWithDuration(0.2, animations: {
                        notif.alpha = 0
                        const.constant = -20
                        self.view.layoutIfNeeded()
                        }, completion: { (complete) in
                            if complete == false {
                                notif.alpha = 0
                                const.constant = -20
                                self.view.layoutIfNeeded()
                            }
                            notif.hidden = true
                    })
                }
            }
        }
    }
    
    @IBAction func buttonTouched(sender: AnyObject) {
        let button = sender as! UIButton
        if let index = buttons.indexOf(button) {
            state.selectTab(index)
        }
    }
    
    // - MARK: Update
    
    func onStateUpdate() {
        if state.tabHasChanged() {
            updateStyle()
        }
        updateNotifs()
    }

}
