//
//  PrivacyVC.swift
//  Mola
//
//  Created by Onur Bostan on 24.10.2024.
//

import UIKit

class PrivacyVC: UIViewController {
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel = PrivacyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyTextView.text = viewModel.getPrivacyPolicyText()
        privacyTextView.isScrollEnabled = true
        privacyTextView.isEditable = false
        privacyTextView.isSelectable = true
    }
}
