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
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        showMotivationMessageIfNeeded()
    }
    private func showMotivationMessageIfNeeded() {
        let lastShownDate = UserDefaults.standard.string(forKey: "lastMotivationDate")
        let today = getCurrentDate()
        if lastShownDate != today {
            showMotivationMessage()
            UserDefaults.standard.set(today, forKey: "lastMotivationDate")
        }
    }
    
    private func showMotivationMessage() {
        let message = viewModel.getMotivationMessage()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Günün Mesajı", message: message, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Devam", style: .default)
            alert.addAction(continueAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveNote(content: textView.text) { success in
                    if success {
                        self.textView.text = ""
                        
                        if let navController = self.navigationController, let notesVC = navController.viewControllers.first(where: { $0 is NotesVC }) as? NotesVC {
                            notesVC.viewModel.loadNotes {
                                notesVC.tableView.reloadData()
             }
            }
            self.navigationController?.popViewController(animated: true)
            } else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Not kaydedilirken hata oluştu!")
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
