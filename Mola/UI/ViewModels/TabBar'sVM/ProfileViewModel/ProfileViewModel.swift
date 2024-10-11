//
//  ProfileViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation

class ProfileViewModel {
    var userData = UserProcesses()
    func signOut(completion: @escaping (Bool) -> Void) {
        userData.signOut { success in
            completion(success)
        }
    }
    
}
