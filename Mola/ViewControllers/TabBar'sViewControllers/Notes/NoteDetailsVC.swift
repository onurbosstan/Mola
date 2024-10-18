//
//  NoteDetailsVC.swift
//  Mola
//
//  Created by Onur Bostan on 14.10.2024.
//

import UIKit

class NoteDetailsVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    var viewModel = NoteDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = viewModel.note {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateLabel.text = dateFormatter.string(from: note.date)
            contentsTextView.text = note.content
        }
        contentsTextView.delegate = self
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let updatedContent = textView.text else { return }
        viewModel.updateNoteContent(newContent: updatedContent) { success in
            if success {
                print("Not başarıyla güncellendi.")
            } else {
                self.showErrorAlert(message: "Not güncellenirken bir hata oluştu.")
            }
        }
        
    }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
