//
//  MenuCollectionViewCell.swift
//  Disk
//
//  Created by Георгий on 17.08.2024.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    let nameServiceLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNameService(nameService: String) {
        nameServiceLabel.text = nameService
        
        self.clipsToBounds = true
    }
    func setupLabel() {
        self.addSubview(nameServiceLabel)
        nameServiceLabel.backgroundColor = .white
        nameServiceLabel.textColor = .black
        nameServiceLabel.translatesAutoresizingMaskIntoConstraints = false
        nameServiceLabel.textAlignment = .center
    }
    
    func setupConstraints() {
        nameServiceLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
}
