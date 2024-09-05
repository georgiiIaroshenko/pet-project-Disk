import FirebaseAuth
import UIKit
import Foundation

class AuthFirebase {
    
    static let shared =  AuthFirebase()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func singUp(email: String,
                password: String,
                nameStorage: NameStorage,
                refreshToken: String,
                accessToken: String,
                idAccessToken: String,
                complition: @escaping (Result<User, Error>) -> ()) {
        
        auth.createUser(withEmail: email,
                        password: password) { result, error in
            
            if let result = result {
                let userStruct = GoogleUserStruct(id: result.user.uid,
                                                  repositories: Storage(
                                                    nameStorage: nameStorage.rawValue,
                                                    accessToken: accessToken,
                                                    refreshToken: refreshToken,
                                                    idAccessToken: idAccessToken))
                DatabaseService.shared.setUser(nameStorage: nameStorage, user: userStruct) { resultDB in
                    switch resultDB {
                    case .success(_):
                        complition(.success(result.user))
                    case .failure(let error):
                        complition(.failure(error))
                    }
                }
            } else if let error = error {
                complition(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, complition: @escaping (Result<User, Error>) -> ()) {
        auth.signIn(withEmail: email, password: password) { result, error in
            
            if let result = result {
                complition(.success(result.user))
            } else if let error = error {
                complition(.failure(error))
            }
        }
    }
    
    func ressetPassword(viewcontroller: UIViewController, login: String ) {
        Auth.auth().sendPasswordReset(withEmail: login) { error in
            if let error = error {
                FactoryAlert.shared.createAlert(viewController: viewcontroller, alertType: .informAlert, title: "Внимание:", message: "\(error.localizedDescription)", buttonCancel: "Закрыть", buttonAction: nil, completion: nil)
            }
                FactoryAlert.shared.createAlert(viewController: viewcontroller, alertType: .informAlert, title: "Внимание:", message: "Проверьте свою почту!", buttonCancel: "Закрыть", buttonAction: nil, completion: nil)
            
        }
        
        
    }
    
}
