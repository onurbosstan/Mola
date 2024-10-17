//
//  NotesViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotesViewModel {
    let db = Firestore.firestore()
    var notes: [Note] = []
    
    func loadNotes(completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion()
            return
        }
        db.collection("notes")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching notes: \(error)")
                } else {
                    self.notes = snapshot?.documents.compactMap { doc -> Note? in
                        let data = doc.data()
                        let content = data["content"] as? String ?? ""
                        let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                        let id = doc.documentID
                        return Note(id: id, content: content, date: date)
                    } ?? []
                    completion()
                }
            }
    }
    func deleteNote(note: Note, completion: @escaping (Bool) -> Void) {
        db.collection("notes").document(note.id).delete { error in
            if let error = error {
                print("Error deleting note: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
