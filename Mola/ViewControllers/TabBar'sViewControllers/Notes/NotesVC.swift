//
//  NotesVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotesVC: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel = NotesViewModel()
    var filteredNotes: [Note] = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredNotes = viewModel.notes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AnimationHelper.showActivityIndicator(animationName: "loading")
        viewModel.loadNotes { [weak self] in
            DispatchQueue.main.async {
                AnimationHelper.hideActivityIndicator()
                self?.filteredNotes = self?.viewModel.notes ?? []
                self?.tableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredNotes = viewModel.notes
            isSearching = false
        } else {
            filteredNotes = viewModel.notes.filter { note in
                return note.content.lowercased().contains(searchText.lowercased())
            }
            isSearching = true
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredNotes = viewModel.notes
        isSearching = false
        tableView.reloadData()
    }
    @IBAction func addButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
}
extension NotesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredNotes.count : viewModel.notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
         let note = isSearching ? filteredNotes[indexPath.row] : viewModel.notes[indexPath.row]
         cell.contentLabel.text = note.content
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = isSearching ? filteredNotes[indexPath.row] : viewModel.notes[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: selectedNote)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC",
           let destinationVC = segue.destination as? NoteDetailsVC {
            if let selectedNote = sender as? Note {
                destinationVC.viewModel.note = selectedNote
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Notu sil", message: "Bu notu silmek istediğinizden emin misiniz?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                let noteToDelete = self.isSearching ? self.filteredNotes[indexPath.row] : self.viewModel.notes[indexPath.row]
                self.viewModel.deleteNote(note: noteToDelete) { success in
                    if success {
                        if let index = self.viewModel.notes.firstIndex(where: { $0.id == noteToDelete.id }) {
                            self.viewModel.notes.remove(at: index)
                        }
                        self.filteredNotes.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        self.showErrorAlert(message: "Not silinirken bir hata oluştu.")
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
