//
//  MemoriesUploadViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 21.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class MemoriesUploadViewModel {
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func uploadMemory(image:UIImage, comment: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }
        let imageID = UUID().uuidString
        let imageRef = storage.child("memories/\(imageID).jpg")
        
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Resim yükleme hatası: \(error.localizedDescription)")
                completion(false)
                return
            }
            imageRef.downloadURL() { url, error in
                if let url = url {
                    self.db.collection("memories").addDocument(data: [
                        "imageURL": url.absoluteString,
                        "comment": comment,
                        "date": Timestamp(date: Date())
                    ]) { error in
                        if let error = error {
                            print("Veri yükleme hatası: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
}
