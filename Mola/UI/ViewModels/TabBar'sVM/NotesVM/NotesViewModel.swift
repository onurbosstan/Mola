//
//  NotesViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

class NotesViewModel {
    let db = Firestore.firestore()
    var notes: [Note] = []
    private let passwordKey = "notesPassword"

    func savePassword(_ password: String) -> Bool {
        return KeychainManager.savePassword(password: password, forKey: passwordKey)
    }

    func getPassword() -> String? {
        return KeychainManager.getPassword(forKey: passwordKey)
    }

    func isPasswordSet() -> Bool {
        return getPassword() != nil
    }

    func validatePassword(_ inputPassword: String) -> Bool {
        return getPassword() == inputPassword
    }
    
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
                        let reminderDate = (data["reminderDate"] as? Timestamp)?.dateValue()
                        return Note(id: id, content: content, date: date, isPinned: isPinned, reminderDate: reminderDate)
                    } ?? []
                    completion()
                }
            }
    }
    func saveNoteWithReminder(content: String, reminderDate: Date?, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion(false)
            return
        }

        var noteData: [String: Any] = [
            "content": content,
            "date": Timestamp(date: Date()),
            "userId": user.uid
        ]

        if let reminderDate = reminderDate {
            noteData["reminderDate"] = Timestamp(date: reminderDate)
        }

        db.collection("notes").addDocument(data: noteData) { error in
            if let error = error {
                print("Error saving note: \(error)")
                completion(false)
            } else {
                if let reminderDate = reminderDate {
                    self.scheduleReminder(content: content, date: reminderDate)
                }
                completion(true)
            }
        }
    }

    func scheduleReminder(content: String, date: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Not Hatırlatıcı"
        notificationContent.body = content
        notificationContent.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling reminder: \(error)")
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
