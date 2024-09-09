//
//  OpenFileCollectionViewCell.swift
//  Disk
//
//  Created by Георгий on 11.08.2024.
//

import UIKit

class OpenFileCollectionViewImageCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

            imageView.contentMode = .scaleAspectFit

                    NSLayoutConstraint.activate([
                        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
                    ])
    }
}
