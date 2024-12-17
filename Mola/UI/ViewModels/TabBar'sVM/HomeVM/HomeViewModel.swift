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
        "Pazartesi": "Deneyecek olanlar için imkansız diye bir şey yoktur! 🚀",
        "Salı": "Kendi hayatını sen belirliyorsun. Başkalarının senaryonu yazmasına izin verme.  💪",
        "Çarşamba": "Bir şey için çok geç olduğunu düşünsen dahi aslında hala erkendir. 🏁",
        "Perşembe": "Bugün yürümezsen yarın koşmak zorunda kalacaksın. 🌟",
        "Cuma": "Hayal edebildiğiniz her şey, gerçektir. 🎉",
        "Cumartesi": "Bugün dinlenme günü! 🛋️",
        "Pazar": "Bütün başarıların başlangıç noktası arzulamaktır. Zayıf arzular, zayıf sonuçlar getirir.  🌞"
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
