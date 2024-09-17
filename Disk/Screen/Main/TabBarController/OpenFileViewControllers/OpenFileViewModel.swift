//
//  OpenFileViewModel.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit


class OpenFileViewModel: ShowAlert, PerformRequest, MimeType, GoogleDriveRequest, ImageRequestProtocol, ActivityViewFullScreen {
    
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
    
    func handleSuccessFiles(_ files: [GoogleFile], imageView: UIImageView?, viewController: UIViewController, completion: @escaping () -> ()) async throws {
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
                let data = try await self.getDataOneFileGoogleDrive(fileID: url)
                DispatchQueue.main.async {
                    if let imageView = imageView {
                        imageView.image = UIImage(data: data)
                        completion()
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
                            completion()
                        }
                    }
                } catch {
                    print("Ошибка загрузки изображения: \(error)")
                }
            }
        }
    }
    
    func requestAudioFileId(viewController: UIViewController, completion: @escaping (Result<Data, NetworkError>) -> Void) async {
//        DispatchQueue.main.async {
//            self.showActivityIndicator(view: viewController.view)
//        }
        performRequest(
            request: { self.requestsGoogleOneFile(nameStorage: .google, fileID: self.idFile, completion: $0) },
            success: { fileId in
                Task {
                    do {
                        self.file?.removeAll()
                        self.file?.append(fileId)
                        
//                        guard let fileId = self.file?.first else {
//                            print("Ошибка: файл не найден")
//                            DispatchQueue.main.async {
//                                completion(.failure(.noData))
//                            }
//                            return
//                        }
                        guard let audioURL = fileId.id else {
                            print("Ошибка: URL аудиофайла отсутствует")
                            DispatchQueue.main.async {
                                completion(.failure(.noData))
                            }
                            return
                        }
                        
                        let data = try await self.getDataOneFileGoogleDrive(fileID: audioURL)
                        DispatchQueue.main.async {
                            completion(.success(data))
                        }
                    } catch {
                        print("Ошибка при обработке файлов: \(error)")
                        DispatchQueue.main.async {
                            completion(.failure(.noData))
                        }
                    }
                }
            },
            failure: { error in
                self.showErrorAlert(viewController: viewController, message: error)
                completion(.failure(.noData))
            }
        )
    }
    
    func requestImageFileId(viewController: UIViewController, imageView: UIImageView) {
        DispatchQueue.main.async {
            self.showActivityIndicator(view: viewController.view)
        }
        performRequest(
            request: { self.requestsGoogleOneFile(nameStorage: .google, fileID: self.idFile, completion: $0) },
            success: { fileId in
                Task {
                    do {
                        try await self.handleSuccessFiles([fileId], imageView: imageView, viewController: viewController) {
                            DispatchQueue.main.async {
                                self.hideActivityIndicator()
                            }
                        }
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
                        try await self.handleSuccessFiles(files, imageView: nil, viewController: UIViewController()) {
                            self.hideActivityIndicator()
                        }
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

