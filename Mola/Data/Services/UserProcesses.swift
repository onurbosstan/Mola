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
        guard let email = email, let password = password else {
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Kayıt sırasında hata: \(error.localizedDescription)")
                completion(false)
            } else {
                Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                    if let error = error {
                        print("Doğrulama e-postası gönderilemedi: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Doğrulama e-postası gönderildi")
                        completion(true)
                    }
                })
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
    func deleteAccount(password: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false)
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("Yeniden kimlik doğrulama başarısız: \(error)")
                completion(false)
                return
            }
            user.delete { error in
                if let error = error {
                    print("Hesap silme başarısız: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
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
