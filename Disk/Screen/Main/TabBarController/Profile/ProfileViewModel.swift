
import UIKit
import GoogleSignIn
import FirebaseAuth
import Charts

class ProfileViewModel: ShowAlert, GoogleDriveRequest, ImageRequestProtocol {
//    var googleUser: GoogleUserStruct?
    var fileUser: UserAbout?
    
    var coordinator: ProfileCoordinator?
    
    init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
    }
    
    private func fullSpace() -> Double {
        let fullSize = Double((fileUser?.storageQuota.limit)!)!
//        let gdfg = Double((fileUser?.storageQuota.usage)!)!
//        let fullSizeToString = String(describing: fullSize)
//        let fullSizeTo = String(describing: gdfg)
//        let fdg = ConvertWeight(sizeString: fullSizeToString).convertWeight()
//        print("Размер хранилища --- \(fdg) ---")
        return fullSize
    }
    
    func fullSize() -> String {
        let fullSize = String(fullSpace())
        let fdg = ConvertWeight(sizeString: fullSize).convertWeight()
        return fdg
    }
    
    func freeSpace() -> Double {
        let fullSize = self.fullSpace()
        let usedSpace = Double((fileUser?.storageQuota.usage)!)!
        let freeSpace = fullSize - usedSpace
        let freeSpaceEnd = freeSpace / (fullSize / 100)
        print(freeSpaceEnd)
        return freeSpaceEnd
    }
    
    func usedSpace() -> Double {
        let fullSize = self.fullSpace()
        let usedSpace = Double((fileUser?.storageQuota.usage)!)!
        let sfsdf = usedSpace / (fullSize / 100)
        print(sfsdf)
        return sfsdf
        
    }
    
    func requestAbout(imageViewGoogleUser: UIImageView, complited:@escaping () -> ()) {
        requestsGoogleAbout() { [weak self]  result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let resultAbout):
                strongSelf.fileUser = resultAbout
                complited()
                Task {
                    do {
                        let data = try await strongSelf.universalGetImage(stringURL: resultAbout.user.photoLink)
                        DispatchQueue.main.async {
                            imageViewGoogleUser.image = UIImage(data: data)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            imageViewGoogleUser.image = UIImage(systemName: "questionmark")
                        }
                    }
                }
            case .failure(let errorAbout):
                print("errorAbout: \(errorAbout)")
                complited()
            }
        }
    }
    
    @objc func rightNavirationBarButtomAction(viewController: UIViewController) {
        showAlertCustom(viewController: viewController,
                        alertType: .oneActionButton,
                        title: "Предупреждение",
                        message: "Вы собираетесь выйти с учетной записи",
                        buttonCancel: "Закрыть",
                        buttonAction: "Выйти") { [weak self]_ in
            self?.coordinator?.finish()
            try! Auth.auth().signOut()
        }
    }
}
