//
//  ForgotPasswordViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 7.10.2024.
//

import Foundation

class ForgotPasswordViewModel {
    var userData = UserProcesses()
    func forgotPassword(email: String, completion: @escaping (Error?) -> Void) {
        userData.forgotPassword(email: email) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
