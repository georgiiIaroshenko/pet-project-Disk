
import UIKit
import GoogleSignIn
import FirebaseAuth

class ProfileViewModel: ShowAlert, GoogleDriveRequest, ImageRequestProtocol {
    private var fileUser: UserAbout?
    private var coordinator: ProfileCoordinator?
    var file: [FilesAbout]?
    
    init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
    }
    
    func requestAbout(imageViewGoogleUser: UIImageView, complited:@escaping () -> ()) {
        requestsGoogleAbout(nameStorage: .google) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let resultAbout):
                strongSelf.file = resultAbout
                strongSelf.fileUser = resultAbout.first?.userAbout
                
                Task {
                    await strongSelf.loadUserImage(urlString: resultAbout.first?.userAbout.user.photoLink, imageView: imageViewGoogleUser)
                    complited()
                }
            case .failure(let errorAbout):
                print("errorAbout: \(errorAbout)")
                complited()
            }
        }
    }
    
    private func loadUserImage(urlString: String?, imageView: UIImageView) async {
            guard let urlString = urlString else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "questionmark")
                }
                return
            }
            do {
                let data = try await universalGetImage(stringURL: urlString)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "questionmark")
                }
            }
        }
    
    @objc func rightNavigationBarButtonAction(viewController: UIViewController) {
        showAlertCustom(
            viewController: viewController,
            alertType: .oneActionButton,
            title: "Предупреждение",
            message: "Вы собираетесь выйти с учетной записи",
            buttonCancel: "Закрыть",
            buttonAction: "Выйти"
        ) { [weak self] _ in
            guard let self = self else { return }
            do {
                try Auth.auth().signOut()
                self.coordinator?.finish()
            } catch let signOutError {
                print("Ошибка выхода: \(signOutError.localizedDescription)")
            }
        }
    }
    func createPieMassiveViewCell() -> PieMassiveViewCell {
        let pieMassive = PieMassiveViewCell(usedSizeDouble: usedSpace(), 
                                            usedSizeString: usedSpaceString(),
                                            freeSizeDouble: freeSpace(),
                                            freeSizeString: freeSpaceString(),
                                            fullSizeString: fullSize())
        return pieMassive
    }
}

extension ProfileViewModel {
    // MARK: - Private Methods

    private func fullSpace() -> Double {
        return Double(fileUser?.storageQuota.limit ?? "") ?? 1
    }
    
    private func usedSpaceRaw() -> Double {
        return Double(fileUser?.storageQuota.usage ?? "") ?? 1
    }
    
    private func freeSpaceRaw() -> Double {
        return fullSpace() - usedSpaceRaw()
    }

    // MARK: - Public Methods

    func fullSize() -> String {
        let convertedFullSize = ConvertWeight(sizeString: String(fullSpace())).convertWeight()
        return "Размер хранилища\n" + "\(convertedFullSize)\n" + (file?.first?.nameStorage ?? "")
    }
    
    func freeSpace() -> Double {
        let freeSpacePercentage = (freeSpaceRaw() / fullSpace()) * 100
        return freeSpacePercentage
    }

    func usedSpace() -> Double {
        let usedSpacePercentage = (usedSpaceRaw() / fullSpace()) * 100
        return usedSpacePercentage
    }

    func usedSpaceString() -> String {
        return ConvertWeight(sizeString: fileUser?.storageQuota.usage ?? "").convertWeight()
    }
    
    func freeSpaceString() -> String {
        let convertedFreeSpace = ConvertWeight(sizeString: "\(freeSpaceRaw())").convertWeight()
        return convertedFreeSpace
    }
    
    func nameMenuCell(indexPath: IndexPath) -> String {
        let nameService = file?[indexPath.item].nameStorage ?? "dsf"
        return nameService
    }
    
    func massiveStorage() -> Int {
        return file?.count ?? 1
    }
}
