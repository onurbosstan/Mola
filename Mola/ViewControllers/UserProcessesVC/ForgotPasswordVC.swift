//
//  ForgotPasswordVC.swift
//  Mola
//
//  Created by Onur Bostan on 3.10.2024.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    let viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetButton(_ sender: Any) {
        if let email = self.emailText.text {
            self.viewModel.forgotPassword(email: email) { error in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: "Yanlış e-posta adresini girdiniz.")
                } else {
                    self.makeAlert(titleInput: "Başarılı!", messageInput: "Şifrenizi sıfırlamanız için e-posta adresinize bir bağlantı gönderildi.")
                }
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
