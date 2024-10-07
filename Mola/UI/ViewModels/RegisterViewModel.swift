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
}
