//
//  UniversalRequests.swift
//  Disk
//
//  Created by Георгий on 26.07.2024.
//

import Foundation
import UIKit

final class UniversalRequest {
    
    static let shared = UniversalRequest()
    
    func universalSetImageFromStringrURL(imageView: UIImageView, stringURL: String) {
        if let url = URL(string: stringURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(systemName: "person.badge.plus")
                    }
                } else  {
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async { [self] in
                        imageView.image = UIImage(data: imageData)
                        ActivityFactory.shared.hideActivityIndicator()
                    }
                }
            }.resume()
        }
    }
}
