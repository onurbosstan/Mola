//
//  MemoriesVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit

class MemoriesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func uploadMemoButton(_ sender: Any) {
        performSegue(withIdentifier: "toUploadMemoVC", sender: nil)
    }
    
}
