//
//  LoginViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/15/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

import UIKit

protocol LoginSignupViewControllerDelegate {
    func dismissLoginSignupViewControllerSuccess()
}


 /*
   LoginViewController, deal with login - once user already has
   created a user with username / password.
 
    Currently this VC also holds the signup view controller logic 
    TODO Separate this out
 
 */

class LoginSignupViewController: UIViewController, SignupViewControllerDelegate {
    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    var delegate:LoginSignupViewControllerDelegate?
    
    @IBOutlet var usernameField: UITextField!
    
    
    @IBOutlet var passwordField: UITextField!
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.hidesWhenStopped = true
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginPressed() {
        self.spinner.startAnimating()
        //TODO  checks for UN and PW integrity here
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!,  block: {
            (user, error) in
            if (error == nil) {
                self.delegate?.dismissLoginSignupViewControllerSuccess()
            } else {
                print("error")
            }
        })
    
    }
    
    
    @IBAction func signupPressed() {
        let signupViewController = self.storyBoard.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        
        signupViewController.delegate = self
        self.presentViewController(signupViewController, animated: true, completion: nil)

        
    }
    
    //Mark SignupViewController Delegate methods
    
    func dismissSignupViewController() {
        self.delegate?.dismissLoginSignupViewControllerSuccess()
    }

}
