//
//  MemoriesVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FirebaseFirestore

class MemoriesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = MemoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchMemories { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMemories {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func uploadMemoButton(_ sender: Any) {
        performSegue(withIdentifier: "toUploadMemoVC", sender: nil)
    }
    
}
extension MemoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoriesCell", for: indexPath) as! MemoriesCell
        let memory = viewModel.memories[indexPath.row]
        cell.dateLabel.text = memory.date
        cell.contentLabel.text = memory.comment
        
        if let url = URL(string: memory.imageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.memoriesImageView.image = UIImage(data: data)
                    }
                }
            }
            cell.deleteAction = { [weak self] in
                self?.presentDeleteAlert(for: memory, at: indexPath)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func presentDeleteAlert(for memory: Memories, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Sil", message: "Bu anıyı silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
            self.deleteMemory(memory, at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func deleteMemory(_ memory: Memories, at indexPath: IndexPath) {
        viewModel.deleteMemory(memory: memory) { [weak self] success in
            if success {
                self?.viewModel.memories.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else {
                print("Anı silinirken bir hata oluştu.")
            }
        }
    }
}
