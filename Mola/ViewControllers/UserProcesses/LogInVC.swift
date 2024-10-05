//
//  ViewController.swift
//  Mola
//
//  Created by Onur Bostan on 2.10.2024.
//

import UIKit

class LogInVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logInButton(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
    @IBAction func newAccountButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewAcc", sender: nil)
    }
    
    @IBAction func hidePasswordButton(_ sender: Any) {
        
    }
    
}

