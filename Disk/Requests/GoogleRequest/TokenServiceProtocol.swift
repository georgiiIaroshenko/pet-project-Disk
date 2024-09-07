
import Foundation

protocol TokenService: NetworkRequest {
    func requestsGoogleCheckToken(completion: @escaping (Result<GoogleTokenInfo, NetworkError>) -> Void)
    func requestsGoogleUpdateToken(completion: @escaping (Result<GoogleNewUserToken, NetworkError>) -> Void)
    func googleCheckAndUpdateToken(completion: @escaping (String) -> Void)
}

extension TokenService {
    func requestsGoogleCheckToken(completion: @escaping (Result<GoogleTokenInfo, NetworkError>) -> Void) {
        DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
            switch result {
            case .success(let accessToken):
                let urlString = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=" + accessToken
                guard let url = URL(string: urlString) else {
                    completion(.failure(.noData))
                    return
                }
                
                performRequest(url: url, httpMethod: "GET", accessToken: accessToken, httpBody: nil, completion: completion)
                print("Получаю токен ассес с БД")
            case .failure(let error):
                print("Ошибка получения данных с БД: \(error.localizedDescription)")
                completion(.failure(.noData))
            }
        }
    }
    
    func requestsGoogleUpdateToken(completion: @escaping (Result<GoogleNewUserToken, NetworkError>) -> Void) {
        DatabaseService.shared.getToken(nameStorage: .google, tokenType: .refreshToken) { result in
            switch result {
            case .success(let refreshToken):
                let urlString = "https://oauth2.googleapis.com/token"
                guard let url = URL(string: urlString) else {
                    completion(.failure(.noData))
                    return
                }
                
                let parameters: [String: Any] = [
                    "client_id": "720844085651-jmc7vvv0mvva1tp7hoefsc0m08vuavnc.apps.googleusercontent.com",
                    "refresh_token": refreshToken,
                    "grant_type": "refresh_token"
                ]
                let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                
                self.performRequest(url: url, httpMethod: "POST", accessToken: "", httpBody: httpBody, completion: completion)
                print("Отправляю рефреш токен в гугл чтобы получить ассес")
            case .failure(let error):
                print("Ошибка получения данных с БД: \(error.localizedDescription)")
                completion(.failure(.noData))
            }
        }
    }
    
    func googleCheckAndUpdateToken(completion: @escaping (String) -> Void) {
        self.requestsGoogleCheckToken { result in
            switch result {
            case .success(let tokenInfo):
                if tokenInfo.expires_in > 300 {
                    completion("Токен актуален")
                    print("Токен актуален")
                } else {
                    self.requestsGoogleUpdateToken { updateResult in
                        switch updateResult {
                        case .success(let newToken):
                            DatabaseService.shared.updateUserKeyFirebaseDatabase(nameStorage: .google, newAccessToken: newToken.access_token)
                            completion("Токен обновлен")
                            print("Токен обновлен")
                        case .failure(let error):
                            print("Ошибка обновления токена: \(error)")
                        }
                    }
                }
            case .failure(let error):
                self.requestsGoogleUpdateToken { updateResult in
                    switch updateResult {
                    case .success(let newToken):
                        DatabaseService.shared.updateUserKeyFirebaseDatabase(nameStorage: .google, newAccessToken: newToken.access_token)
                        completion("Токен обновлен")
                        print("Токен обновлен")
                    case .failure(let error):
                        print("Ошибка обновления токена: \(error)")
                    }
                    print("Ошибка проверки токена: \(error)")
                }
            }
        }
    }
}
