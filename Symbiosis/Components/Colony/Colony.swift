//
//  colonie.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 05/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYColony: UIView, SYStateListener {

    @IBOutlet var view: UIView!
    @IBOutlet weak var colonieName: UILabel!
    @IBOutlet weak var commentaires: UIButton!
    @IBOutlet weak var mainAction: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var exitView: UIView!
    
    let background = Background()
    
    // State
    let state = SYStateManager.sharedInstance
    
    // MARK: Init
    var nibName: String = "Colony"

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
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        commentaires.titleLabel?.textColor = background.hexStringToUIColor("#BBB3B3")
        commentaires.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        colonieName.textColor = background.hexStringToUIColor("#FF6A4D")
        
        updateStyle()
        
        self.userInteractionEnabled = true
        
        //view?.superview!.hidden = true
        mainAction.addTarget(self, action:#selector(self.mainActionTouch), forControlEvents: .TouchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.hideColonie))
        exitView.addGestureRecognizer(gesture)
        
        state.addListener(self)
    }
    
    func hideColonie(){
        state.dispatchAction(SYStateActionType.SelectSeed, payload: nil)
        state.dispatchAction(SYStateActionType.HideCurrentPopup, payload: nil)
    }
    
    func mainActionTouch() {
        state.dispatchAction(SYStateActionType.SetUserSeed, payload: nil)
        state.dispatchAction(SYStateActionType.SelectSeed, payload: nil)
        state.dispatchAction(SYStateActionType.HideCurrentPopup, payload: nil)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func updateStyle() {
        stackView.layoutIfNeeded()
        stackView.layoutSubviews()
        let height = stackView.frame.height
        let width = stackView.frame.width
        let roundSize: CGFloat = 40
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: roundSize))
        path.addLineToPoint(CGPoint(x: 0, y: height))
        path.addLineToPoint(CGPoint(x: width, y: height))
        path.addLineToPoint(CGPoint(x: width, y: roundSize))
        path.addCurveToPoint(CGPoint(x: width/2, y: 0), controlPoint1: CGPoint(x: width, y: roundSize), controlPoint2: CGPoint(x: width * 0.75, y: 0))
        path.addCurveToPoint(CGPoint(x: 0, y: roundSize), controlPoint1: CGPoint(x: width * 0.25, y: 0), controlPoint2: CGPoint(x: 0, y: roundSize))
        path.closePath()
        
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.fillColor = UIColor.whiteColor().CGColor
        shape.zPosition = -1
        // Shadow
        shape.shadowPath = path.CGPath
        shape.shadowColor = UIColor.blackColor().CGColor
        shape.shadowOffset = CGSizeMake(0.0, 0.0)
        shape.shadowOpacity = 0.15;
        shape.shadowRadius = 10
        // Add
        stackView.layer.addSublayer(shape)
    }
    @IBAction func showComments(sender: AnyObject) {
        state.dispatchAction(SYStateActionType.SetCommentDisplay, payload: true)
    }
    
    // MARK: State
    
    func onStateSetup() {
        let seed = state.getSelectedSeed()
        colonieName.text = seed?.name
        colonieName.textColor = background.hexStringToUIColor("#FF6A4D")
        
        print("Setup")
        
        print(state.userHasSeed())
        
        if state.userHasSeed() {
            self.mainAction.setTitle("RETOURNER SUR LA CARTE", forState: UIControlState.Normal)
        } else {
            self.mainAction.setTitle("SELECTIONER CETTE GRAINE", forState: UIControlState.Normal)
        }
    }
    
    func onStateUpdate() {
        if self.state.selectedSeedHasChanged() {
            self.onStateSetup()
        }
    }
}