//
//  MainProtocol.swift
//  Disk
//
//  Created by Георгий on 04.09.2024.
//

import Foundation
import UIKit

protocol CreatePlaceholder {
    func createPlaceholder(for key: LocalizedKeys, localized: String) -> String
}

extension CreatePlaceholder {
    func createPlaceholder(for key: LocalizedKeys, localized: String) -> String {
        return NSLocalizedString(key.rawValue, tableName: localized, comment: "")
    }
}

extension String {
    func localized(tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "****\(self)****", comment: "")
    }
}
protocol ShowAlert {
    func showAlert(viewController: UIViewController, alertType: AlertType, title: String, message: String, buttonCancel: String?, buttonAction: String?, completion: ((String) -> Void)?)
}

extension ShowAlert {
    func showAlert(viewController: UIViewController, alertType: AlertType, title: String, message: String, buttonCancel: String?, buttonAction: String?, completion: ((String) -> Void)?) {
        FactoryAlert.shared.createAlert(viewController: viewController, alertType: alertType, title: title, message: message, buttonCancel: buttonCancel, buttonAction: buttonAction, completion: completion)
    }
}

