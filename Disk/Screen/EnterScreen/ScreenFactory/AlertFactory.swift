//
//  AlertFactory.swift
//  Disk
//
//  Created by Георгий on 18.07.2024.
//

import Foundation
import UIKit

enum AlertType {
    
    case informAlert, oneActionButton, textField, onlyActionButton
}

class FactoryAlert {
    static let shared = FactoryAlert()
    
    func createAlert(viewController: UIViewController,
                     alertType: AlertType,
                     title: String,
                     message: String,
                     buttonCancel: String? ,
                     buttonAction: String? ,
                     completion: ((String) -> Void)? ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
            let action = UIAlertAction(title: title, style: style, handler: handler)
            alert.addAction(action)
        }
        
        switch alertType {
            
        case .informAlert:
            addAction(title: buttonCancel, style: .cancel, handler: nil)
            
        case .oneActionButton:
            addAction(title: buttonAction, style: .default) { _ in
                completion?("sdf")
            }
            addAction(title: buttonCancel, style: .cancel, handler: nil)
            
        case .textField:
            alert.addTextField { field in
                field.placeholder = "Введите текст"
            }
            addAction(title: buttonAction, style: .default) { _ in
                if let text = alert.textFields?.first?.text, !text.isEmpty {
                    completion?(text)
                } else {
                    FactoryAlert.shared.createAlert(viewController: viewController,
                                                    alertType: .informAlert,
                                                    title: "Внимание",
                                                    message: "Имя должно содержать хотя бы 1 символ",
                                                    buttonCancel: "Закрыть",
                                                    buttonAction: nil, completion: nil)
                }
            }
            addAction(title: buttonCancel, style: .cancel, handler: nil)
            
        case .onlyActionButton:
            addAction(title: buttonAction, style: .default) { _ in
                completion?("fg")
            }
        }
        viewController.present(alert, animated: true)
    }
}
        



