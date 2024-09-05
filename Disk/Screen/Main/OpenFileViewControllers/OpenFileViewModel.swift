//
//  OpenFileViewModel.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit


class OpenFileViewModel: ShowAlert {
    
    var idFile: String
    var nameFile: String
    var mimeType: String
    var webContentLink: String?
    var file: [GoogleFile]?
    
    var coordinator: LatterFileCoordinator
    
    init(idFile: String, nameFile: String, coordinator: LatterFileCoordinator, mimeType: String, webContentLink: String?) {
        self.idFile = idFile
        self.nameFile = nameFile
        self.mimeType = mimeType
        self.coordinator = coordinator
        self.webContentLink = webContentLink
    }
    
    func getImage(imageView: UIImageView, url: String) {
        UniversalRequest.shared.universalSetImageFromStringrURL(imageView: imageView, stringURL: url)
    }

    func handleSuccessFiles(_ files: [GoogleFile], imageView: UIImageView?, viewController: UIViewController) {
        self.file?.removeAll()
        self.file = files
        
        if let fileId = files.first, let imageView = imageView {
            let imageURL = fileId.thumbnailLink ?? fileId.iconLink
            guard let url = imageURL else {
                print("Ошибка: URL изображения отсутствует")
                return
            }
            DispatchQueue.main.async {
                self.getImage(imageView: imageView, url: url)
            }
        }
    }
    
    func requestOneFileId(viewController: UIViewController, imageView: UIImageView) {
        GoogleRequest.shared.requestsGoogleOneFile(fileID: self.idFile) { [weak self] result in
                switch result {
                case .success(let fileId):
                    DispatchQueue.main.async {
                        self?.handleSuccessFiles([fileId], imageView: imageView, viewController: viewController)
                    }
                case .failure(let error):
                    print("Ошибка скачивания - \(error.localizedDescription)")
                }
            }
    }
    
    func requestFolderFileId(completion: @escaping () -> ()) {
                GoogleRequest.shared.requestsGoogleFolderFile(idFile: self.idFile) { [weak self] result in
                    switch result {
                    case .success(let files):
                        DispatchQueue.main.async {
                            self?.handleSuccessFiles(files, imageView: nil, viewController: UIViewController())
                        }
                        completion()
                    case .failure(let error):
                        print("Ошибка скачивания - \(error.localizedDescription)")
                    }
                }
    }
    
    func renameActionRightBarButton(navigationItem: UINavigationItem, viewController: UIViewController) {
        DispatchQueue.main.async {
            self.showAlert(
                viewController: viewController,
                alertType: .textField,
                title: "Внимание",
                message: "Введите новое имя",
                buttonCancel: "Закрыть",
                buttonAction: "Переименовать"
            ) { [weak self] newName in
                guard let self = self else { return }
                GoogleRequest.shared.requestsUpdateNameGoogleFile(fileID: self.idFile, newName: newName) { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self?.nameFile = newName
                            navigationItem.title = newName
                            self?.showAlert(
                                viewController: viewController,
                                alertType: .informAlert,
                                title: "Внимание",
                                message: "Файл успешно переименован",
                                buttonCancel: "Закрыть",
                                buttonAction: nil, completion: nil
                            )
                        }
                    case .failure(let error):
                        self?.showAlert(
                            viewController: viewController,
                            alertType: .informAlert,
                            title: "Внимание",
                            message: error.localizedDescription,
                            buttonCancel: "Закрыть",
                            buttonAction: nil, completion: nil
                        )
                        print("Ошибка переименования - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func deleteGoogleFile(navigationItem: UINavigationItem, viewController: UIViewController) {
        self.showAlert(
            viewController: viewController,
            alertType: .oneActionButton,
            title: "Внимание",
            message: "Вы уверены, что хотите удалить файл?",
            buttonCancel: "Закрыть",
            buttonAction: "Удалить"
        ) { [weak self] _ in
            guard let self = self else { return }
            GoogleRequest.shared.requestsDeleteGoogleFile(fileID: self.idFile) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(
                            viewController: viewController,
                            alertType: .onlyActionButton,
                            title: "Внимание",
                            message: "Файл успешно удален",
                            buttonCancel: nil,
                            buttonAction: "Назад"
                        ) {[weak self] _ in
                            if let navigationController = viewController.navigationController {
                                navigationController.popViewController(animated: true)
                            } else {
                                viewController.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(
                            viewController: viewController,
                            alertType: .informAlert,
                            title: "Внимание",
                            message: error.localizedDescription,
                            buttonCancel: "Закрыть",
                            buttonAction: nil, completion: nil
                        )
                    }
                }
            }
        }
    }
    
    func actionShareButton(viewController: UIViewController) {
        guard let webContentLink = webContentLink else {
            print("webContentLink не установлен")
            return
        }
        
        let items: [Any] = [webContentLink]
        
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(avc, animated: true)
    }
}

