//
//  ChatViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 04/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let state = SYStateManager.sharedInstance

    @IBOutlet weak var colonyName: UILabel!
    let userData = UserSingleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colonyName.text = "Notre-Dame"

    }
    
    override func viewDidAppear(animated: Bool) {
        state.dispatchAction(SYStateActionType.SetUnreadMessages, payload: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func closeChat(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
