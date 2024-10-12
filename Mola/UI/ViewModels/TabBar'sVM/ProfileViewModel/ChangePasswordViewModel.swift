//
//  ChangePasswordViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 12.10.2024.
//

import Foundation

class ChangePasswordViewModel {
    var userData = UserProcesses()
    func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        userData.changePassword(newPassword: newPassword) { error in
            completion(error)
        }
    }
    func verifyCurrentPassword(currentPassword: String, completion: @escaping (Bool) -> Void) {
        let isPasswordCorrect = true
        completion(isPasswordCorrect)
    }
}
