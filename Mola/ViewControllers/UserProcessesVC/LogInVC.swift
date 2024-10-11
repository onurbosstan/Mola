//
//  ViewController.swift
//  Mola
//
//  Created by Onur Bostan on 2.10.2024.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    let viewModel = LogInViewModel()
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
    }
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !email.isEmpty && !password.isEmpty && viewModel.isValidEmail(email) {
            viewModel.signIn(email: email, password: password) { error in
                if let error = error {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                } else {
                    self.viewModel.updateTabBar()
                }
            }
        } else {
            self.makeAlert(titleInput: "Error!", messageInput: "Please enter a valid email address and password.")
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
    @IBAction func newAccountButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewAcc", sender: nil)
    }
    
    @IBAction func hidePasswordButton(_ sender: Any) {
        passwordText.isSecureTextEntry.toggle()
        iconClick.toggle()
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}

