//
//  ProgressViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 3.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProgressViewModel {
    private let db = Firestore.firestore()
    private var notes: [Note] = []
    var totalNotes: Int = 0
    var mostActiveDay: String = ""
    var badges: [String] = []
    
    func fetchNotes(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion(false)
            return
        }

        db.collection("notes").whereField("userId", isEqualTo: userId).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching notes: \(error)")
                completion(false)
                return
            }

            self.notes = snapshot?.documents.compactMap { document in
                let data = document.data()
                let content = data["content"] as? String ?? ""
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                let id = document.documentID
                return Note(id: id, content: content, date: date, isPinned: false)
            } ?? []

            self.calculateProgress()
            completion(true)
        }
    }

    private func calculateProgress() {
        totalNotes = notes.count
        
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: notes) { note in
            calendar.component(.weekday, from: note.date)
        }
        if let mostActiveDayEntry = groupedByDay.max(by: { $0.value.count < $1.value.count }) {
            self.mostActiveDay = calendar.weekdaySymbols[mostActiveDayEntry.key - 1]
        }
        calculateBadges()
    }

    private func calculateBadges() {
        badges.removeAll()
        
        if totalNotes >= 1 {
            badges.append("İlk Notunu Oluşturdun!")
        }
        if totalNotes >= 50 {
            badges.append("50 Not Barajını Geçtin!")
        }
        if !mostActiveDay.isEmpty {
            badges.append("Haftanın En Aktif Günü: \(mostActiveDay)")
        }
    }
}
