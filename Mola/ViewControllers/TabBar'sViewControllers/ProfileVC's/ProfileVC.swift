//
//  ProfileVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProfileViewModel()
    let menuOptions: [[(title: String, image: String, bgColor: UIColor, iconColor: UIColor)]] = [ [
            (title: "Email Değiştir", image: "envelope.circle", bgColor: .systemGreen ,iconColor: .white),
            (title: "Şifre Değiştir", image: "lock.fill", bgColor: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), iconColor: .white),
            (title: "Gizlilik Politikamız", image: "newspaper.fill", bgColor: UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 0.5), iconColor: .white),
            (title: "Hesabımı Sil", image: "trash.circle.fill", bgColor: .systemGray3, iconColor: .white),
            (title: "Çıkış Yap", image: "rectangle.portrait.and.arrow.right", bgColor: .red, iconColor: .white)]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    private func showDeleteAccountAlert() {
           let alert = UIAlertController(title: "Hesabınızı Silin", message: "Lütfen şifrenizi girin", preferredStyle: .alert)
           alert.addTextField { (textField) in
               textField.placeholder = "Şifrenizi girin"
               textField.isSecureTextEntry = true
           }
           let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
               if let password = alert.textFields?.first?.text {
                   self?.viewModel.deleteAccount(password: password) { success in
                       if success {
                           self?.navigateToLogin()
                       } else {
                           self?.makeAlert(titleInput: "Hata", messageInput: "Hesap silme işlemi başarısız.")
                       }
                   }
               }
           }
           let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
           
           alert.addAction(deleteAction)
           alert.addAction(cancelAction)
           
           self.present(alert, animated: true)
       }
       
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC") as? LogInVC {
            let navigationController = UINavigationController(rootViewController: logInVC)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIView.transition(with: UIApplication.shared.windows.first!,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil,
                                completion: nil)
        }
    }
}
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let item = menuOptions[indexPath.section][indexPath.row]
        cell.iconView.backgroundColor = item.bgColor
        cell.iconImageView.image = UIImage(systemName: item.image)
        cell.iconImageView.tintColor = item.iconColor
        cell.optionsLabel.text = item.title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toChangeEmail", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "toChangePassword", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "toPrivacyVC", sender: nil)
        case 3:
            showDeleteAccountAlert()
        case 4:
            viewModel.logOut()
        default:
            break
        }
    }
}
