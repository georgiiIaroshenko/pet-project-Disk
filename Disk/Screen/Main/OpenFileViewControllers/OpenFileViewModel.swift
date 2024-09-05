//
//  OpenFileViewModel.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit


class OpenFileViewModel: ShowAlert, PerformRequest {
    
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
//        GoogleRequest.shared.requestsGoogleOneFile(fileID: self.idFile) { [weak self] result in
//                switch result {
//                case .success(let fileId):
//                    DispatchQueue.main.async {
//                        self?.handleSuccessFiles([fileId], imageView: imageView, viewController: viewController)
//                    }
//                case .failure(let error):
//                    print("Ошибка скачивания - \(error.localizedDescription)")
//                }
//            }
        
        performRequest(
                request: { GoogleRequest.shared.requestsGoogleOneFile(fileID: self.idFile, completion: $0) },
                success: { [weak self] fileId in
                    self?.handleSuccessFiles([fileId], imageView: imageView, viewController: viewController)
                },
                failure: { error in
                    self.showErrorAlert(viewController: viewController, message: error)
                }
            )
    }
    
    func requestFolderFileId(completion: @escaping () -> ()) {
//                GoogleRequest.shared.requestsGoogleFolderFile(idFile: self.idFile) { [weak self] result in
//                    switch result {
//                    case .success(let files):
//                        DispatchQueue.main.async {
//                            self?.handleSuccessFiles(files, imageView: nil, viewController: UIViewController())
//                        }
//                        completion()
//                    case .failure(let error):
//                        print("Ошибка скачивания - \(error.localizedDescription)")
//                    }
//                }
        
        performRequest(
                request: { GoogleRequest.shared.requestsGoogleFolderFile(idFile: self.idFile, completion: $0) },
                success: { [weak self] files in
                    self?.handleSuccessFiles(files, imageView: nil, viewController: UIViewController())
                    completion()
                },
                failure: { error in
                    print("Ошибка скачивания - \(error.localizedDescription)")
                }
            )
    }
    
    func renameActionRightBarButton(navigationItem: UINavigationItem, viewController: UIViewController) {
        DispatchQueue.main.async {
            self.showAlertCustom(
                viewController: viewController,
                alertType: .textField,
                title: AlertTexts.attention,
                message: AlertTexts.enterNewName,
                buttonCancel: AlertTexts.close,
                buttonAction: AlertTexts.rename
            ) { [weak self] newName in
                guard let self = self else { return }
                
                performRequest(
                        request: { GoogleRequest.shared.requestsUpdateNameGoogleFile(fileID: self.idFile, newName: newName, completion: $0) },
                        success: { [weak self] files in
                            self?.nameFile = newName
                            navigationItem.title = newName
                            self?.showSuccessAlertInform(viewController: viewController, message: AlertTexts.successRename)
                        },
                        failure: { error in
                            self.showErrorAlert(viewController: viewController, message: error)
                            print("Ошибка переименования - \(error.localizedDescription)")
                        }
                    )
                
                
//                GoogleRequest.shared.requestsUpdateNameGoogleFile(fileID: self.idFile, newName: newName) { [weak self] result in
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async {
//                            self?.nameFile = newName
//                            navigationItem.title = newName
//                            self?.showSuccessAlertInform(viewController: viewController, message: AlertTexts.successRename)
//                        }
//                    case .failure(let error):
//                        self?.showErrorAlert(viewController: viewController, message: error)
//                        print("Ошибка переименования - \(error.localizedDescription)")
//                    }
//                }
            }
        }
    }
    
    func deleteGoogleFile(navigationItem: UINavigationItem, viewController: UIViewController) {
        self.showAlertCustom(
            viewController: viewController,
            alertType: .oneActionButton,
            title: AlertTexts.attention,
            message: AlertTexts.deleteFile,
            buttonCancel: AlertTexts.close,
            buttonAction: AlertTexts.delete
        ) { [weak self] _ in
            guard let self = self else { return }
            
            performRequest(
                    request: { GoogleRequest.shared.requestsDeleteGoogleFile(fileID: self.idFile, completion: $0) },
                    success: { [weak self] _ in
                        self!.showSuccessAlertAction(viewController: viewController, message: AlertTexts.successDelete)
                        {_ in 
                            viewController.navigationController?.popViewController(animated: true)
                        }
                    },
                    failure: { error in
                        self.showErrorAlert(viewController: viewController, message: error)
                        print("Ошибка переименования - \(error.localizedDescription)")
                    }
                )
            
            
//            GoogleRequest.shared.requestsDeleteGoogleFile(fileID: self.idFile) { result in
//                switch result {
//                case .success:
//                    DispatchQueue.main.async {
//                        self.showSuccessAlertAction(viewController: viewController, message: AlertTexts.successDelete, buttonAction: AlertTexts.close)
//                        {[weak self] _ in
//                            if let navigationController = viewController.navigationController {
//                                navigationController.popViewController(animated: true)
//                            } else {
//                                viewController.dismiss(animated: true, completion: nil)
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showErrorAlert(viewController: viewController, message: error)
//                    }
//                }
//            }
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

