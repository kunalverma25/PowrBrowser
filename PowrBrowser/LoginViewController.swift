//
//  LoginViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import Firebase
import UIView_Shake

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(FIRAuth.auth()?.currentUser)
        if FIRAuth.auth()?.currentUser != nil {
            performSegue(withIdentifier: "inApp", sender: nil)
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailField.text == "" || passwordField.text == "" {
            emailField.shake()
            passwordField.shake()
        }
        else {
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, err) in
            if err == nil {
                self.performSegue(withIdentifier: "inApp", sender: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
        }
    }
    
    

}
