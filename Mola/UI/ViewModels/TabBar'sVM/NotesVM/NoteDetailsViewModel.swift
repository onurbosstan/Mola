//
//  NoteDetailsViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 14.10.2024.
//

import Foundation
import FirebaseFirestore

class NoteDetailsViewModel {
    var note: Note?

    func updateNoteContent(newContent: String, completion: @escaping (Bool) -> Void) {
        guard let noteId = note?.id else {
            completion(false)
            return
        }
        let db = Firestore.firestore()
        db.collection("notes").document(noteId).updateData([
            "content": newContent,
            "date": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error updating note: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
