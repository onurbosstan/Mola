//
//  LogInViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 7.10.2024.
//

import Foundation
import FirebaseAuth
import UIKit

class LogInViewModel {
    var userData = UserProcesses()
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        userData.signIn(email: email, password: password) { error in
            if let error = error {
                completion(error)
            } else {
              completion(nil)
            }
        }
    }
    
    func updateTabBar() {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            let board = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(identifier: "tabBar") as! UITabBarController
            tabBar.selectedIndex = 2
            UIApplication.shared.windows.first?.rootViewController = tabBar
            UIView.transition(with: UIApplication.shared.windows.first!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
