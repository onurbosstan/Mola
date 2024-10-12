//
//  ChangeEmailViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 12.10.2024.
//

import Foundation

class ChangeEmailViewModel {
    var userData = UserProcesses()
    func changeEmail(newEmail: String, completion: @escaping (Error?) -> Void) {
        userData.changeEmail(newEmail: newEmail) { error in
            completion(error)
        }
    }
    
}
