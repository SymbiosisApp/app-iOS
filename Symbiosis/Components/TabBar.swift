//
//  TabBar.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 13/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYTabBar: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var plantButton: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet var buttons: Array<UIButton>!
    
    var delegate: SYTabBarDelegate?
    
    var selectedItem: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "TabBar", bundle: nil).instantiateWithOwner(self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        
        applyStyle()
        selectItem(0)
        
    }
    
    func applyStyle() {
        
        self.layoutIfNeeded()
        
        // Background
        background.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.blackColor().CGColor
        background.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        background.layer.shadowOpacity = 0.5;
        // background.layer.backgroundColor = UIColor.redColor().CGColor
        print(background.layer.bounds)
        
        background.layer.shadowRadius = 5
        let backShadowPath = UIBezierPath(rect: background.layer.bounds)
        background.layer.shadowPath = backShadowPath.CGPath;
        
        // PlantButton
        plantButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        plantButton.layer.masksToBounds = false
        plantButton.layer.shadowColor = UIColor.blackColor().CGColor
        plantButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        plantButton.layer.shadowOpacity = 0.08;
        plantButton.layer.shadowRadius = 5
        plantButton.layer.cornerRadius = plantButton.layer.bounds.width/2
        let plantShadowPath = UIBezierPath(ovalInRect: plantButton.layer.bounds)
        plantButton.layer.shadowPath = plantShadowPath.CGPath;
    }
    
    func updateStyle() {
        for (index, button) in buttons.enumerate() {
            if index == selectedItem {
                button.selected = true
            } else {
                button.selected = false
            }
        }
    }
    
    func selectItem(index: Int) {
        if index != selectedItem {
            selectedItem = index
            updateStyle()
            self.delegate?.onTabSelected(selectedItem)
        }
    }
    
    @IBAction func selectTab(sender: AnyObject) {
        let button = sender as! UIButton
        if let index = buttons.indexOf(button) {
            selectItem(index)
        }
    }
    
}

protocol SYTabBarDelegate: class {
    func onTabSelected(tabIndex: Int)
}
