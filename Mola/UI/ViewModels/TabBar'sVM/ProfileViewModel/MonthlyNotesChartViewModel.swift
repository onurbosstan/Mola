//
//  MonthlyNotesChartViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 28.11.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MonthlyNotesChartViewModel {
    private let db = Firestore.firestore()
    private var notes: [Note] = []
    var monthlyNoteCounts: [Int: Int] = [:]
    
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
                let isPinned = data["isPinned"] as? Bool ?? false
                return Note(id: id, content: content, date: date, isPinned: isPinned)
            } ?? []
            
            self.calculateMonthlyNoteCounts()
            completion(true)
        }
    }
    
    private func calculateMonthlyNoteCounts() {
        let calendar = Calendar.current
        let groupedNotes = Dictionary(grouping: notes) { note in
            calendar.component(.month, from: note.date)
        }
        
        monthlyNoteCounts = Array(1...12).reduce(into: [Int: Int]()) { result, month in
            result[month] = 0
        }
        for (month, notes) in groupedNotes {
            monthlyNoteCounts[month] = notes.count
        }
    }
}
