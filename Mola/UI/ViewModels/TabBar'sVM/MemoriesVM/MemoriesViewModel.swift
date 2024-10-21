//
//  MemoriesViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation
import FirebaseFirestore

class MemoriesViewModel {
    var memories: [Memories] = []
    let db = Firestore.firestore()
    
    func fetchMemories(completion: @escaping () -> Void) {
        db.collection("memories").order(by: "date", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Anılar yüklenirken hata oluştu: \(error.localizedDescription)")
                completion()
                return
            }
            self.memories = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                let date = (data["date"] as? Timestamp)?.dateValue().description ?? ""
                let comment = data["comment"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                return Memories(date: date, comment: comment, imageURL: imageURL)
            } ?? []
            completion()
        }
    }
}
