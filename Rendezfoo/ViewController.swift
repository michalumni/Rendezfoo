//
//  ViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/15/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

import UIKit

/*
 Entry point to program just display the appropriate view controller
 depending on if the user has logged in/created account. If user
 is already cached display the MainViewController
 
 
*/

class ViewController: UIViewController, LoginSignupViewControllerDelegate {
    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard (PFUser.currentUser() != nil) else {
            presentLoginViewController()
            return
        }
        
        presentMainViewController()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentLoginViewController() {
        let loginViewController = self.storyBoard.instantiateViewControllerWithIdentifier("LoginSignupViewController") as! LoginSignupViewController
        loginViewController.delegate = self
        //matchAcceptedViewController.transitioningDelegate = self
        //matchAcceptedViewController.delegate = self
        //matchAcceptedViewController.modalPresentationStyle = .Custom
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func presentMainViewController() {
        print("print main vc")
        let mainViewController = self.storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let navigation:UINavigationController = UINavigationController(rootViewController: mainViewController)
        //matchAcceptedViewController.transitioningDelegate = self
        //matchAcceptedViewController.delegate = self
        //matchAcceptedViewController.modalPresentationStyle = .Custom
        
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    //MARK LoginViewControllerDelegate
    
    func dismissLoginSignupViewControllerSuccess() {
        self.dismissViewControllerAnimated(false, completion: {
            self.presentMainViewController()
        })
    }


}

