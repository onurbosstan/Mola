//
//  ProgressVC.swift
//  Mola
//
//  Created by Onur Bostan on 3.12.2024.
//

import UIKit

class ProgressVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProgressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        fetchProgressData()
    }
    private func fetchProgressData() {
        viewModel.fetchNotes { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                print("Veriler alınırken bir hata oluştu.")
            }
        }
    }
}
extension ProgressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath) as? ProgressCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Toplam Not Sayısı"
            cell.contentLabel.text = "\(viewModel.totalNotes)"
        case 1:
            cell.titleLabel.text = "En Aktif Gün"
            cell.contentLabel.text = viewModel.mostActiveDay.isEmpty ? "Henüz yok" : viewModel.mostActiveDay
        case 2:
            cell.titleLabel.text = "Rozetler"
            cell.contentLabel.text = viewModel.badges.isEmpty ? "Henüz rozet yok" : viewModel.badges.joined(separator: ", ")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
