//
//  MemoriesCell.swift
//  Mola
//
//  Created by Onur Bostan on 20.10.2024.
//

import UIKit

class MemoriesCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memoriesImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deleteMenuButton: UIButton!
    var deleteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteAction?()
    }
    
}
