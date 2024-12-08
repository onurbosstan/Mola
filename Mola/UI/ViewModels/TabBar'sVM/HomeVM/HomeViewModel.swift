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
    
    private let dailyMessages: [String: String] = [
        "Pazartesi": "Sizi gerçekten motive edebilen tek kişi kendinizdir. 🚀",
        "Salı": "Bugün içinde bulunduğunuz mücadele, yarın ihtiyacınız olan gücü geliştiriyor. 💪",
        "Çarşamba": "Binlerce kilometrelik bir yolculuk bile, tek bir adımla başlar. 🏁",
        "Perşembe": "Gelişimini engelleyen bütün arzularından kurtul ve hedeflerine ilerle. 🌟",
        "Cuma": "Konu işlerin yürütülmesine gelince, motivasyon her şeydir. 🎉",
        "Cumartesi": "Bugün dinlenme günü! 🛋️",
        "Pazar": "Zaferin coşkusunu hissedebilmeniz için zorlukları kabul edin. 🌞"
    ]
    
    func getMotivationMessage() -> String {
        let today = getDayOfWeek()
        return dailyMessages[today] ?? "Bugün için bir mesajımız yok!"
    }
    private func getDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: Date())
    }
    
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
