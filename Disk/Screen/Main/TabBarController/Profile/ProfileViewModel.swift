
import UIKit
import GoogleSignIn
import FirebaseAuth

class ProfileViewModel: ShowAlert, GoogleDriveRequest, ImageRequestProtocol {
    var googleUser: GoogleUserStruct = GoogleUserStruct(id: "", repositories: Storage(nameStorage: "", accessToken: "", refreshToken: "", idAccessToken: ""))
    var fileUser: UserGL?
    
    var coordinator: ProfileCoordinator?
    
    init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
    }
    
    func requestAbout(imageViewGoogleUser: UIImageView) {
        
        requestsGoogleAbout() { result in
            switch result {
            case .success(let resultAbout):
                self.fileUser = resultAbout.user
                Task {
                    do {
                        let data = try await self.universalGetImage(stringURL: self.fileUser?.photoLink ?? "")
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
