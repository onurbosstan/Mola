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
    let db = Firestore.firestore()
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        
    }
    
}
