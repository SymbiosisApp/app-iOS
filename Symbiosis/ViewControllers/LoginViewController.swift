//
//  LoginViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

  
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    let user = UserSingleton.sharedInstance;
    let request = RequestData()
    let background = Background()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.adddImageBaclground(self.view, imageSource: "loginBackground.png")
        
        //if isset login
//        if(self.user.getUserData()["userId"] != nil){
//            let id:Int = Int(self.user.getUserData()["userId"]! as! NSNumber);
//            print(request.getData("http://localhost:8080/users/id=\(id)&param=all"));
//
//            dispatch_async(dispatch_get_main_queue()) {
//                self.performSegueWithIdentifier("loginCheked", sender: self)
//            }
//        }
        
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if "loginCheked" == segue.identifier {
//            print("login cheked go to map");
//        }
//    }
    

    @IBAction func loginValidation(sender: AnyObject) {
        
//        if(!pseudo.text!.isEmpty && !email.text!.isEmpty && !mdp.text!.isEmpty){
//            let data:[String:AnyObject] = [
//                "pseudo":pseudo.text!,
//                "email":email.text!,
//                "mdp":mdp.text!
//            ]
            
            //POST and callaback PostResponse
//            request.postData(data, url: "http://localhost:8080/user/"){
//                (result: String) in
//                 //use server response
//                self.user.setUserData(Int(result)!, pseudo: self.pseudo.text!, email: self.email.text!, mdp: self.mdp.text!)
//                print("getSingleton ", UserSingleton.sharedInstance.getUserData());
//            }
//        }
        
//        self.performSegueWithIdentifier("loginCheked", sender: self)
        
    }

    //TODO post userParent after seed choice
//    self.user.setUserData(Int(parent))

}

