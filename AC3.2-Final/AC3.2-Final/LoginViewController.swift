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

//loginOrRegisterSuccessSegueIdentifier

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var firUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let userEmail = emailTextField.text,
            let userPassword = passwordTextField.text else {
                let errorAlertController = UIAlertController(title: " Registration Error", message: "Missing information in Email/ Password", preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        FIRAuth.auth()?.signIn(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                //print("Error present when login button is pressed")
                let errorAlertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
            } else {
                guard let validUser = user else { return }
                self.firUser = validUser
                self.performSegue(withIdentifier: "loginOrRegisterSuccessSegueIdentifier", sender: sender)
            }
        })
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let userEmail = self.emailTextField.text,
            let userPassword = self.passwordTextField.text else {
                let errorAlertController = UIAlertController(title: " Registration Error", message: "Missing information in Email/ Password", preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
                return
        }
        FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                let errorAlertController = UIAlertController(title: "Registration Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                errorAlertController.addAction(okay)
                self.present(errorAlertController, animated: true, completion: nil)
            } else {
                guard let validUser = user else { return }
                self.firUser = validUser
                self.performSegue(withIdentifier: "loginOrRegisterSuccessSegueIdentifier", sender: sender)                
            }
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "loginOrRegisterSuccessSegueIdentifier" {
//            let mainTabViewController = segue.destination
//        }
//    }
}

