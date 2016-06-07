//
//  CommentsViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 07/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController, SYStateListener {
    
    @IBOutlet weak var colonyName: UILabel!
    
    let state = SYStateManager.sharedInstance
    
    override func viewDidLoad() {
        state.addListener(self)
    }
    
    @IBAction func closeComments(sender: AnyObject) {
        state.dispatchAction(SYStateActionType.SetCommentDisplay, payload: false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onStateSetup() {
        let colony = state.getSelectedSeed()
        self.colonyName.text = colony!
        
        print(colony)
        
    }
    
    func onStateUpdate() {
        if self.state.selectedSeedHasChanged() {
            self.onStateSetup()
        }
    }
}