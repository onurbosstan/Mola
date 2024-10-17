//
//  NotesVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = NotesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadNotes { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        
    }
    
}
extension NotesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        let note = viewModel.notes[indexPath.row]
        cell.textLabel?.text = note.content
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = viewModel.notes[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: selectedNote)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
