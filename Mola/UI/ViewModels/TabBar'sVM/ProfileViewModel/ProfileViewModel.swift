//
//  ProfileViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewModel {
    var userData = UserProcesses()
    func signOut(completion: @escaping (Bool) -> Void) {
        userData.signOut { success in
            completion(success)
        }
    }
    func logOut() {
        userData.signOut { success in
            if success {
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
    }
    func deleteAccount(password: String, completion: @escaping (Bool) -> Void) {
        userData.deleteAccount(password: password) { success in
            completion(success)
        }
    }
    func validateNotePassword(_ inputPassword: String) -> Bool {
        return KeychainManager.getPassword(forKey: "notesPassword") == inputPassword
    }

    func changeNotePassword(newPassword: String) {
        KeychainManager.savePassword(password: newPassword, forKey: "notesPassword")
    }
}
