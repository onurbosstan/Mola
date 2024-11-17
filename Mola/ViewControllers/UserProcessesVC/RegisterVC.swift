//
//  RegisterVC.swift
//  Mola
//
//  Created by Onur Bostan on 3.10.2024.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var viewModel = RegisterViewModel()
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    @IBAction func registerButton(_ sender: Any) {
        guard let email = self.emailText.text, let password = self.passwordText.text else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen geçerli bir e-posta ve şifre girin.")
            return
        }
        if !viewModel.isValidEmail(email) {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen geçerli bir e-posta adresi girin.")
            return
        }
        self.viewModel.signUp(email: email, password: password) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.makeAlert(titleInput: "Başarılı!", messageInput: "Doğrulama e-postası gönderildi. Lütfen e-postanızı kontrol edin.")
            } else {
                self.makeAlert(titleInput: "Hata!", messageInput: "Kayıt işlemi başarısız. Lütfen tekrar deneyin.")
            }
        }
    }
    @IBAction func hidePasswordButton(_ sender: Any) {
        if iconClick {
            passwordText.isSecureTextEntry = false
        } else {
            passwordText.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
