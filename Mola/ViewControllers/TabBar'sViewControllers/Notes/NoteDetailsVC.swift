//
//  NoteDetailsVC.swift
//  Mola
//
//  Created by Onur Bostan on 14.10.2024.
//

import UIKit

class NoteDetailsVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    var viewModel = NoteDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = viewModel.note {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateLabel.text = dateFormatter.string(from: note.date)
            contentsLabel.text = note.content
        }
        
    }


}
