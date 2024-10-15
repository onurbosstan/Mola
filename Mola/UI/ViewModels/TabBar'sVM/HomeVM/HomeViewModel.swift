//
//  HomeViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import FirebaseFirestore
import FirebaseAuth

class HomeViewModel {
    let db = Firestore.firestore()
    
    func saveNote(content: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser, !content.isEmpty else {
            completion(false)
            return
        }
        
        let noteData: [String: Any] = [
            "content": content,
            "date": Timestamp(date: Date()),
            "userId": user.uid
        ]
        
        db.collection("notes").addDocument(data: noteData) { error in
            if let error = error {
                print("Error saving note: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
