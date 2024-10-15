//
//  AddNoteVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let noteText = textView.text, !noteText.isEmpty else {
            return
        }
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        let noteData: [String: Any] = [
            "content": noteText,
            "date": Timestamp(date: Date()),
            "userId": user.uid
        ]
        db.collection("Notes").addDocument(data: noteData) { error in
            if let error = error {
                self.makeAlert(titleInput: "Hata!", messageInput: "Notunuz kaydedilmedi.")
            } else {
                self.textView.text = ""
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
extension HomeVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    }
}
