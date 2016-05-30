//
//  LoginViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    //TODO create storyboard with this elements
    @IBOutlet var pseudo: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var mdp: UITextField!
    
    let user = UserSingleton.sharedInstance;
    let request = RequestData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground("loginBackground.png")
        
        //if isset login
        if(self.user.getUserData()["userId"] != nil){
            let id:Int = Int(self.user.getUserData()["userId"]! as! NSNumber);
            print(request.getData("http://localhost:8080/users/id=\(id)&param=all"));
            
            dispatch_async(dispatch_get_main_queue()) {
                //TODO add identifier and storyboard
                //self.performSegueWithIdentifier("login", sender: self)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "login" == segue.identifier {
            print("go to map");
        }
    }
    
    
    @IBAction func login(sender: AnyObject) {
        if(!pseudo.text!.isEmpty && !email.text!.isEmpty && !mdp.text!.isEmpty){
            let data:[String:AnyObject] = [
                "pseudo":pseudo.text!,
                "email":email.text!,
                "mdp":mdp.text!
            ]
            
            //POST and callaback PostResponse
            request.postData(data, url: "http://localhost:8080/user/"){
                (result: String) in
                self.user.setUserData(Int(result)!, pseudo: self.pseudo.text!, email: self.email.text!, mdp: self.mdp.text!)
                //print("getSingleton ", UserSingleton.sharedInstance.getUserData());
            }
        }
    }
    
    //TODO post userParent after seed choice
    //self.user.setUserData(Int(parent))
    
    
    //TODO assign background at one storyboard ?
    //set backgroundImage
    func assignbackground(background:NSString){
        let background = UIImage(named: background as String)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    
}

