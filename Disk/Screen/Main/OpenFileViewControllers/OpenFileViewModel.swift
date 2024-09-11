//
//  OpenFileViewModel.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit


class OpenFileViewModel: ShowAlert, PerformRequest, MimeType, GoogleDriveRequest, ImageRequestProtocol {
    
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
    
    func handleSuccessFiles(_ files: [GoogleFile], imageView: UIImageView?, viewController: UIViewController) async throws {
        self.file?.removeAll()
        self.file = files
        
        if let fileId = files.first {
            var imageURL: String?
            
            if fileId.mimeType!.contains("image") {
                imageURL = fileId.id
                guard let url = imageURL else {
                    print("Ошибка: URL изображения отсутствует")
                    return
                }
                let data = try await self.getImageGoogleDrive(fileID: url)
                DispatchQueue.main.async {
                    if let imageView = imageView {
                        imageView.image = UIImage(data: data)
                    }
                }
            } else {
                imageURL = fileId.thumbnailLink ?? fileId.iconLink
                
                guard let url = imageURL else {
                    print("Ошибка: URL изображения отсутствует")
                    return
                }
                do {
                    let imageData = try await universalGetImage(stringURL: url)
                    DispatchQueue.main.async {
                        if let imageView = imageView {
                            imageView.image = UIImage(data: imageData)
                        }
                    }
                } catch {
                    print("Ошибка загрузки изображения: \(error)")
                }
            }
        }
    }
    
    func requestOneFileId(viewController: UIViewController, imageView: UIImageView) {
        performRequest(
            request: { self.requestsGoogleOneFile(nameStorage: .google, fileID: self.idFile, completion: $0) },
            success: { fileId in
                Task {
                    do {
                        try await self.handleSuccessFiles([fileId], imageView: imageView, viewController: viewController)
                    } catch {
                        print("Ошибка при обработке файлов: \(error)")
                    }
                }
            },
            failure: { error in
                self.showErrorAlert(viewController: viewController, message: error)
            }
        )
    }
    
    func requestFolderFileId(completion: @escaping () -> ()) {
        performRequest(
            request: { self.requestsGoogleFolderFile(nameStorage: .google, idFile: self.idFile, completion: $0) },
            success: { files in
                Task {
                    do {
                        try await self.handleSuccessFiles(files, imageView: nil, viewController: UIViewController())
                        completion()
                    } catch {
                        print("Ошибка при обработке файлов: \(error)")
                    }
                }
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
                    request: { self.requestsUpdateNameGoogleFile(nameStorage: .google, fileID: self.idFile, newName: newName, completion: $0) },
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
                request: { self.requestsDeleteGoogleFile(nameStorage: .google, fileID: self.idFile, completion: $0) },
                success: { [weak self] _ in
                    self?.showSuccessAlertAction(viewController: viewController, message: AlertTexts.successDelete)
                    {_ in 
                        viewController.navigationController?.popViewController(animated: true)
                    }
                },
                failure: { error in
                    self.showErrorAlert(viewController: viewController, message: error)
                    print("Ошибка переименования - \(error.localizedDescription)")
                }
            )
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

