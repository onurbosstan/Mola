//
//  UserProcesses.swift
//  Mola
//
//  Created by Onur Bostan on 5.10.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserProcesses {
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            }else {
                completion(nil)
            }
        }
    }
    func signUp(email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        if let mail = email, let password = password {
            let user = Users(email: mail, password: password)
            let data = ["email": user.email, "password": user.password]
            Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                if error == nil {
                    let myUsers = Firestore.firestore()
                    let userCollection = myUsers.collection("Users").document(authResult?.user.uid ?? "").collection(user.email)
                    userCollection.document("UserInfo").setData(data) { error in
                        if error != nil {
                        completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    func forgotPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                completion(error)
            }
        } else {
            completion(nil)
        }
    }
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    func changeEmail(newEmail: String, completion: @escaping (Error?) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            completion(error)
        }
    }
}
