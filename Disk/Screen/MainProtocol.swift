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
    func showAlertCustom(viewController: UIViewController, alertType: AlertType, title: String, message: String, buttonCancel: String?, buttonAction: String?, completion: ((String) -> Void)?)
    func showErrorAlert(viewController: UIViewController, message: Error)
    func showSuccessAlertAction(viewController: UIViewController, message: String, completion: ((String) -> Void)?)
    func showSuccessAlertInform(viewController: UIViewController, message: String)
}

extension ShowAlert {
    func showAlertCustom(viewController: UIViewController, alertType: AlertType, title: String, message: String, buttonCancel: String?, buttonAction: String?, completion: ((String) -> Void)?) {
        FactoryAlert.shared.createAlert(viewController: viewController, alertType: alertType, title: title, message: message, buttonCancel: buttonCancel, buttonAction: buttonAction, completion: completion)
    }
    
    func showErrorAlert(viewController: UIViewController, message: Error) {
        FactoryAlert.shared.createAlert(viewController: viewController, alertType: .informAlertCustom, title: AlertTexts.attention, message: message.localizedDescription, buttonCancel: AlertTexts.close, buttonAction: nil, completion: nil)
    }
    
    func showSuccessAlertAction(viewController: UIViewController, message: String, completion: ((String) -> Void)?) {
        FactoryAlert.shared.createAlert(viewController: viewController, alertType: .oneActionButton, title: AlertTexts.attention, message: message, buttonCancel: AlertTexts.close, buttonAction: nil, completion: completion)
    }
    
    func showSuccessAlertInform(viewController: UIViewController, message: String) {
        FactoryAlert.shared.createAlert(viewController: viewController, alertType: .informAlertCustom, title: AlertTexts.attention, message: message, buttonCancel: AlertTexts.close, buttonAction: nil, completion: nil)
    }
}

enum AlertTexts {
    static let attention = "Внимание"
    static let deleteFile = "Вы уверены, что хотите удалить файл?"
    static let delete = "Удалить"
    static let close = "Закрыть"
    static let rename = "Переименовать"
    static let successRename = "Файл успешно переименован"
    static let successDelete = "Файл успешно удален"
    static let enterNewName = "Введите новое имя"
}

protocol ActivityViewFullScreen {
    func showActivityIndicator(view: UIView)
    func hideActivityIndicator()
}


extension ActivityViewFullScreen {
    func showActivityIndicator(view: UIView) {
        ActivityFactory.shared.showActivityIndicator(in: view)
    }
    func hideActivityIndicator() {
        ActivityFactory.shared.hideActivityIndicator()
    }
}
