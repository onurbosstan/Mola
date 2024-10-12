//
//  ChangePasswordVC.swift
//  Mola
//
//  Created by Onur Bostan on 12.10.2024.
//

import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var currentPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    var viewModel = ChangePasswordViewModel()
    var currentIconClick = true
    var newPasswordIconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        guard let currentPassword = currentPasswordText.text, !currentPassword.isEmpty else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen mevcut şifrenizi giriniz.")
            return
        }
        guard let newPasword = newPasswordText.text, !newPasword.isEmpty else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen yeni bir şifre girin.")
            return
        }
        viewModel.verifyCurrentPassword(currentPassword: currentPassword) { [weak self] isValidPassword in
            guard let self = self else { return }
            if isValidPassword {
                self.viewModel.changePassword(newPassword: newPasword) { [weak self] error in
                    if let error = error {
                        self?.makeAlert(titleInput: "Hata!", messageInput: "Şifre değiştirme hatalı: \(error.localizedDescription)!")
                    } else {
                        self?.makeAlert(titleInput: "Başarılı!", messageInput: "Şifre başarıyla değiştirildi.")
                    }
                }
            } else {
                self.makeAlert(titleInput: "Hata!", messageInput: "Mevcut şifre yanlış.")
            }
        }
    }
    
    @IBAction func currentEyeButton(_ sender: Any) {
        currentPasswordText.isSecureTextEntry.toggle()
        currentIconClick.toggle()
    }
    
    @IBAction func newPasswordEyeButton(_ sender: Any) {
        newPasswordText.isSecureTextEntry.toggle()
        newPasswordIconClick.toggle()
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
