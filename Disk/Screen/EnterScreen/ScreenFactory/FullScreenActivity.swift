//
//  ActivityFactory.swift
//  Disk
//
//  Created by Георгий on 25.08.2024.
//

import UIKit
import SnapKit

class ActivityFactory {
    static let shared = ActivityFactory()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium) 
        ai.backgroundColor = .white
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private init() {}
    
    func showActivityIndicator(in view: UIView) {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
