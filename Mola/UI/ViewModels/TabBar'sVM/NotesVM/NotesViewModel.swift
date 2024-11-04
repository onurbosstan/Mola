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
                        let isPinned = data["isPinned"] as? Bool ?? false
                        return Note(id: id, content: content, date: date, isPinned: isPinned)
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
    func getNotes(for date: Date) -> [Note] {
            let calendar = Calendar.current
            return notes.filter {
                calendar.isDate($0.date, inSameDayAs: date)
            }
        }
    func togglePin(for note: Note, completion: @escaping (Bool) -> Void) {
            let noteRef = db.collection("notes").document(note.id)
            let newPinStatus = !note.isPinned

            noteRef.updateData(["isPinned": newPinStatus]) { error in
                if let error = error {
                    print("Error updating pin status: \(error)")
                    completion(false)
                } else {
                    if let index = self.notes.firstIndex(where: { $0.id == note.id }) {
                        self.notes[index].isPinned = newPinStatus
                }
                completion(true)
            }
        }
    }
}
