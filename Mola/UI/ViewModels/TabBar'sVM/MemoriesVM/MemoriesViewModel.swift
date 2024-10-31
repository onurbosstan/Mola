//
//  MemoriesViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MemoriesViewModel {
    var memories: [Memories] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    func fetchMemories(completion: @escaping () -> Void) {
        db.collection("memories").order(by: "date", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Anılar yüklenirken hata oluştu: \(error.localizedDescription)")
                completion()
                return
            }
            self.memories = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                let comment = data["comment"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                let documentID = doc.documentID
                return Memories(date: date, comment: comment, imageURL: imageURL, documentID: documentID)
            } ?? []
            completion()
        }
    }
    func deleteMemory(memory: Memories, completion: @escaping (Bool) -> Void) {
        let imageRef = storage.reference(forURL: memory.imageURL)
        imageRef.delete { error in
            if let error = error {
                print("Resim silinirken hata oluştu: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.db.collection("memories").document(memory.documentID).delete { error in
                if let error = error {
                    print("Belge silinirken hata oluştu: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
