//
//  ViewController.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var firUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                let errorAlertController = UIAlertController(title: "Sign In Anonymously Failed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
            }
            guard let validUser = user else { return }
            self.firUser = validUser
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let userEmail = emailTextField.text,
            let userPassword = passwordTextField.text else {
                let errorAlertController = UIAlertController(title: "Login Failed", message: "Missing information in Email/ Password", preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        self.loginButton.isEnabled = false
        FIRAuth.auth()?.signIn(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                //print("Error present when login button is pressed")
                let errorAlertController = UIAlertController(title: "Login Failed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
                self.loginButton.isEnabled = true
            } else {
                guard let validUser = user else { return }
                self.firUser = validUser
                self.performSegue(withIdentifier: "loginOrRegisterSuccessSegueIdentifier", sender: sender)
                self.loginButton.isEnabled = true
            }
        })
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let userEmail = self.emailTextField.text,
            let userPassword = self.passwordTextField.text else {
                let errorAlertController = UIAlertController(title: " Registration Failed", message: "Missing information in Email/ Password", preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
                return
        }
        self.registerButton.isEnabled = false
        FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                let errorAlertController = UIAlertController(title: "Registration Failed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
                self.registerButton.isEnabled = true
            } else {
                guard let validUser = user else { return }
                self.firUser = validUser
                self.performSegue(withIdentifier: "loginOrRegisterSuccessSegueIdentifier", sender: sender)
                self.registerButton.isEnabled = true
            }
        })
    }
}

