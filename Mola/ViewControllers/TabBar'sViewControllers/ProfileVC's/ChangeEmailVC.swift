//
//  ChangeEmailVC.swift
//  Mola
//
//  Created by Onur Bostan on 12.10.2024.
//

import UIKit

class ChangeEmailVC: UIViewController {
    @IBOutlet weak var newEmailText: UITextField!
    var viewModel = ChangeEmailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func confirmButton(_ sender: Any) {
        guard let newEmail = newEmailText.text, !newEmail.isEmpty else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen yeni eposta adresinizi girin.")
            return
        }
        viewModel.changeEmail(newEmail: newEmail) { error in
            if let error = error {
                self.makeAlert(titleInput: "Hata!", messageInput: "E-posta değiştirilirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                self.makeAlert(titleInput: "Başarılı!", messageInput: "E-posta adresiniz başarıyla değiştirildi.")
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
