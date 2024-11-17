//
//  RegisterViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 7.10.2024.
//

import Foundation

class RegisterViewModel {
    var userData = UserProcesses()
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        userData.signUp(email: email, password: password) { result in
            completion(result)
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
