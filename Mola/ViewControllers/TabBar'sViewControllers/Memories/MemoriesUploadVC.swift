//
//  MemoriesDetailVC.swift
//  Mola
//
//  Created by Onur Bostan on 20.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CropViewController

class MemoriesUploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var clickImageView: UIImageView!
    @IBOutlet weak var contentText: UITextField!
    var viewModel = MemoriesUploadViewModel()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        clickImageView.isUserInteractionEnabled = true
        clickImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    @objc func selectImage() {
        let alert = UIAlertController(title: "Fotoğraf Seç", message: "Lütfen bir seçenek seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Kamerayı aç", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Kütüphaneden aç", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.makeAlert(titleInput: "Hata", messageInput: "Kamera kullanılamıyor.")
        }
    }
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                let cropViewController = CropViewController(image: image)
                cropViewController.delegate = self
                self.present(cropViewController, animated: true, completion: nil)
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        clickImageView.image = image
        selectedImage = image
    }
    
    @IBAction func sendButton(_ sender: Any) {
        guard let image = selectedImage else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen bir fotoğraf seçin")
            return
        }
        let comment = contentText.text ?? ""
        viewModel.uploadMemory(image: image, comment: comment) { success in
            if success {
                print("Başarıyla yüklendi!")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.makeAlert(titleInput: "Hata", messageInput: "Yükleme sırasında bir hata oluştu.")
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
