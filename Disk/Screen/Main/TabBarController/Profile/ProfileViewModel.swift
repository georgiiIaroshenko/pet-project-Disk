
import UIKit
import GoogleSignIn
import FirebaseAuth

class ProfileViewModel: ShowAlert {
    var googleUser: GoogleUserStruct = GoogleUserStruct(id: "", repositories: Storage(nameStorage: "", accessToken: "", refreshToken: "", idAccessToken: ""))
    var fileUser: UserGL?
    
    var coordinator: ProfileCoordinator?
    
    init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
    }
    
    func requestAbout(imageViewGoogleUser: UIImageView) {
        
        GoogleRequest.shared.requestsGoogleAbout() { result in
            switch result {
            case .success(let resultAbout):
                self.fileUser = resultAbout.user
                self.setImageFromStringrURL(imageViewGoogleUser: imageViewGoogleUser)
            case .failure(let errorAbout):
                print("errorAbout: \(errorAbout)")
            }
        }
    }
    
    func setImageFromStringrURL(imageViewGoogleUser: UIImageView) {
        UniversalRequest.shared.universalSetImageFromStringrURL(imageView: imageViewGoogleUser, stringURL: fileUser?.photoLink ?? "")
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
