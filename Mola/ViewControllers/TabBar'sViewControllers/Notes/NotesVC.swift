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
    var selectedDate: Date?
    var isSearching: Bool = false
    var isFiltered: Bool = false
    var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredNotes = viewModel.notes
        
        if !viewModel.isPasswordSet() {
            askForPasswordSetup()
        } else {
            authenticateUser()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAuthenticated {
            loadNotes()
        } else {
            authenticateUser()
        }
    }
    
    private func askForPasswordSetup() {
        let alert = UIAlertController(title: "Şifre Kullanmak İster misiniz?", message: "Notlarınızı korumak için bir şifre belirleyebilirsiniz.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Şifre"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { textField in
            textField.placeholder = "Şifreyi Tekrar Girin"
            textField.isSecureTextEntry = true
        }

        let saveAction = UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let password = alert.textFields?.first?.text ?? ""
            let confirmPassword = alert.textFields?[1].text ?? ""

            if password.isEmpty || password != confirmPassword {
                self.showErrorAlert(message: "Şifreler uyuşmuyor. Lütfen tekrar deneyin.") {
                    self.askForPasswordSetup()
                }
            } else if self.viewModel.savePassword(password) {
                print("Şifre kaydedildi.")
                self.authenticateUser()
            } else {
                self.showErrorAlert(message: "Şifre kaydedilemedi.") {
                    self.askForPasswordSetup()
                }
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { [weak self] _ in
            print("Şifre belirlenmedi. Notlara erişim kısıtlandı.")
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func authenticateUser() {
        let alert = UIAlertController(title: "Şifre", message: "Notlarınıza erişmek için şifrenizi girin.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Şifre"
            textField.isSecureTextEntry = true
        }

        let loginAction = UIAlertAction(title: "Giriş", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let inputPassword = alert.textFields?.first?.text ?? ""

            if self.viewModel.validatePassword(inputPassword) {
                print("Şifre doğru. Notlara erişim sağlandı.")
                self.isAuthenticated = true
                self.loadNotes()
            } else {
                self.showErrorAlert(message: "Şifre yanlış. Lütfen tekrar deneyin.") {
                    self.authenticateUser()
                }
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { [weak self] _ in
            print("Kullanıcı notlara erişimi iptal etti.")
        }

        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func loadNotes() {
        guard isAuthenticated else {
            print("Kullanıcı doğrulanmadı. Notlar yüklenmiyor.")
            return
        }

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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredNotes.filter { $0.isPinned }.count
        } else {
            return filteredNotes.filter { !$0.isPinned }.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && !filteredNotes.filter({ $0.isPinned }).isEmpty {
            return "İğnelenmiş"
        } else if section == 1 {
            return "Notlar"
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        let note: Note
        if indexPath.section == 0 {
            note = filteredNotes.filter { $0.isPinned }[indexPath.row]
        } else {
            note = filteredNotes.filter { !$0.isPinned }[indexPath.row]
        }
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "İğnele") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            var note: Note
            if indexPath.section == 0 {
                note = self.filteredNotes.filter { $0.isPinned }[indexPath.row]
            } else {
                note = self.filteredNotes.filter { !$0.isPinned }[indexPath.row]
            }
            self.viewModel.togglePin(for: note) { success in
                if success {
                    note.isPinned.toggle()
                    self.filteredNotes = self.viewModel.notes
                    self.tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        pinAction.backgroundColor = UIColor.systemYellow
        return UISwipeActionsConfiguration(actions: [pinAction])
        }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let note: Note
            if indexPath.section == 0 {
                note = self.filteredNotes.filter { $0.isPinned }[indexPath.row]
            } else {
                note = self.filteredNotes.filter { !$0.isPinned }[indexPath.row]
            }
                
            let alert = UIAlertController(title: "Notu sil", message: "Bu notu silmek istediğinizden emin misiniz?", preferredStyle: .alert)
            let deleteAlertAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                self.viewModel.deleteNote(note: note) { success in
                    if success {
                        if let index = self.viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                            self.viewModel.notes.remove(at: index)
                        }
                        self.filteredNotes.removeAll(where: { $0.id == note.id })
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        self.showErrorAlert(message: "Not silinirken bir hata oluştu.")
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            alert.addAction(deleteAlertAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
