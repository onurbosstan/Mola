//
//  LogInViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 7.10.2024.
//

import Foundation

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
}
