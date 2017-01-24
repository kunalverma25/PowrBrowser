//
//  SignUpViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import UIView_Shake
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if emailField.text == "" || passwordField.text == "" {
            emailField.shake()
            passwordField.shake()
        }
        else {
            
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        
                        changeRequest.displayName = self.nameField.text!
                        changeRequest.photoURL =
                            URL(string: "")
                        changeRequest.commitChanges { error in
                            if let error = error {
                                print("Error")
                            } else {
                                self.performSegue(withIdentifier: "inApp", sender: nil)
                            }
                        }
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    

}
