//
//  SignupViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/15/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//
protocol SignupViewControllerDelegate {
    func dismissSignupViewController()
}

 /*
 Signup for an account create username, email, password
 TODO -- email verification, all error checking.
 */

class SignupViewController: UIViewController {
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var usernameField: UITextField!
    var delegate:SignupViewControllerDelegate?
    
    @IBOutlet var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.hidesWhenStopped = true

        
    }
    
    
    @IBAction func signupPressed() {
        self.spinner.startAnimating()
        
        let newUser = PFUser()
        
        newUser.email = emailField.text
        newUser.password = passwordField.text
        newUser.username = usernameField.text
        
        newUser.signUpInBackgroundWithBlock({(success, error) in
            if (success) {
                self.delegate?.dismissSignupViewController()
                print("success user was created")
            } else {
                print("error")
            }
            
        })
        
    
    
    }
    
}
