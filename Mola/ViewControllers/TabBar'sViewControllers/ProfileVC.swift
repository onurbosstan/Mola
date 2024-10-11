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
            (title: "Change E-Mail Address", image: "envelope.circle", bgColor: .gray ,iconColor: .white),
            (title: "Change Password", image: "lock.fill", bgColor: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), iconColor: .white),
            (title: "Logout", image: "rectangle.portrait.and.arrow.right", bgColor: .red, iconColor: .white)]]
    
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
            viewModel.logOut()
        default:
            break
        }
    }
}
