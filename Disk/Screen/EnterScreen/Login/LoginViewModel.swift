import GoogleSignIn
import FirebaseAuth
import UIKit
import Combine



class LoginViewModel: ShowAlert {
    
    var coordinator: LoginCoordinator
    @Published var errorMessage: String?
        
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func checkLoginAndPassword(viewController: UIViewController, textFieldLogin: String, textFieldPassword: String, textFieldTwoPassword: String, errorLoginLabel: String, isAuth: Bool) {
        let result = LoginService.shared.checkCredentials(
            login: textFieldLogin,
            password: textFieldPassword,
            passwordTwo: isAuth ? textFieldPassword : textFieldTwoPassword
        )
        switch result {
        case .invalidLogin:
            errorMessage = "Enter correct email"
        case .shortPassword:
            errorMessage = "Password should be more than 6 symbols"
        case .passworNotHaveDigits:
            errorMessage = "Password should have at least one digit"
        case .passwordNotUppercased:
            errorMessage = "Password should have at least one upper letter"
        case .passwordNotLowercased:
            errorMessage = "Password should have at least one lower letter"
        case .passwordsMismatch:
            errorMessage = "Passwords are not identical"
        case .correct:
            errorMessage = nil
            isAuth ? actionEnterButtom(viewController: viewController, textFieldLogin: textFieldLogin, textFieldPassword: textFieldPassword) : actionRegisterButtom(viewController: viewController, textFieldLogin: textFieldLogin, textFieldPassword: textFieldPassword)
        }
    }
    
    func actionEnterButtom(viewController: UIViewController, textFieldLogin: String, textFieldPassword: String) {
        AuthFirebase.shared.signIn(email: textFieldLogin, password: textFieldPassword) { result in
            switch result {
            case .success(_):
                self.coordinator.finish()
                print("")
            case .failure(let error):
                self.showErrorAlert(viewController: viewController, message: error)
            }
        }
    }
    
    func actionRegisterButtom(viewController: UIViewController, textFieldLogin: String, textFieldPassword: String) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.ios",
                                                 installIfNotAvailable: false, minimumVersion: "12")
        
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController, hint: "456",
            additionalScopes: ["https://www.googleapis.com/auth/drive"] )
        { signInResult, error in
            guard let result = signInResult else {
                return
            }
            
            let user = signInResult?.user
            let clientAccessToken = user?.accessToken.tokenString
            let clientRefreshToken = user?.refreshToken.tokenString
            let clientIdToken = user?.idToken?.tokenString
            
            AuthFirebase.shared.singUp(
                email: textFieldLogin,
                password: textFieldPassword,
                nameStorage: .google,
                refreshToken: clientRefreshToken!,
                accessToken: clientAccessToken!,
                idAccessToken: clientIdToken!,
                complition: { result in
                    
                    switch result {
                    case .success(_):
                        print("Firebase - сохранение данных в БД -")
                    case .failure(let error):
                        self.showErrorAlert(viewController: viewController, message: error)
                    }
                }
            )}
    }
    
    @objc func actionRessetPassword(viewController: UIViewController) {
        showAlertCustom(viewController: viewController, alertType: .textField, title: "Сброс пароля", message: "Введите email и на него придет ссылка по востановлению пароля", buttonCancel: "Закрыть", buttonAction: "Сбросить") { email in
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
                    if let error = error {
                        self?.showErrorAlert(viewController: viewController, message: error)
                    } else {
                        self?.showSuccessAlertInform(viewController: viewController, message: "Письмо благополучно отправлено на указаную почту")
                    }
                }
        }
    }
}
