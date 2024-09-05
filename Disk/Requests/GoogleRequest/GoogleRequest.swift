import Foundation
import GoogleSignIn
import GoogleAPIClientForREST_Drive

final class GoogleRequest {
    static let shared = GoogleRequest()
    private let driveService = GTLRDriveService()
    
    private init() {}
    
    // Обработка запросов с декодированием
    private func performRequest<T: Decodable>(url: URL, httpMethod: String, httpBody: Data?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        if httpBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            print("HTTP статус код: \(httpResponse.statusCode)")
            guard (200...299).contains(httpResponse.statusCode) else {
                let error: NetworkError = httpResponse.statusCode == 429 ? .tooManyRequests : .noData
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    // Обработка запросов без декодирования (для Void)
    private func performRequestVoid(url: URL, httpMethod: String, httpBody: Data?, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        if httpBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            print("HTTP статус код: \(httpResponse.statusCode)")
            guard (200...299).contains(httpResponse.statusCode) else {
                let error: NetworkError = httpResponse.statusCode == 429 ? .tooManyRequests : .noData
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    func requestsAllFile(nameStorage: NameStorage, completion: @escaping (Result<[Files], NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files?q='root' in parents and mimeType!='application/vnd.google-apps.shortcut'&fields=nextPageToken,files(id,name,mimeType,size,thumbnailLink,iconLink,modifiedTime,viewedByMeTime,webContentLink)&access_token=\(accessToken)"
                    
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", httpBody: nil) { (result: Result<GoogleStructeFileList, NetworkError>) in
                        switch result {
                        case .success(let decodedObject):
                            let file = [Files(name: nameStorage.rawValue, googleFile: decodedObject.files)]
                            print("Получил все данные!")
                            completion(.success(file))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    func requestsGoogleFolderFile(idFile: String, completion: @escaping (Result<[GoogleFile], NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let requestAllFile = "https://www.googleapis.com/drive/v3/files?q=\"\(idFile)\"+in+parents&fields=files(*)&access_token=\(accessToken)"
                    
                    guard let url = URL(string: requestAllFile) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", httpBody: nil) { (result: Result<GoogleStructeFileList, NetworkError>) in
                        switch result {
                        case .success(let decodedQuery):
                            completion(.success(decodedQuery.files))
                            print("Получил папку")
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                case .failure(let error):
                    print("Ошибка получения данных с БД: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }

    func requestsGoogleAbout(completion: @escaping (Result<UserAbout, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/about?fields=*&access_token=\(accessToken)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", httpBody: nil, completion: completion)
                    print("Получил данные профиля")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }

    func requestsGoogleOneFile(fileID: String, completion: @escaping (Result<GoogleFile, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files/\(fileID)?fields=id,name,size,thumbnailLink,modifiedTime,iconLink,webContentLink&access_token=\(accessToken)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", httpBody: nil) { (result: Result<GoogleFile, NetworkError>) in
                        completion(result)
                    }
                    print("Получил данные одного файла")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    func requestsUpdateNameGoogleFile(fileID: String, newName: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files/\(fileID)?access_token=\(accessToken)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    let httpBody = try? JSONSerialization.data(withJSONObject: ["name": newName], options: [])
                    
                    self.performRequestVoid(url: url, httpMethod: "PATCH", httpBody: httpBody, completion: completion)
                    print("Обновляю имя файла")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    func requestsDeleteGoogleFile(fileID: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { [weak self] _ in
            guard let self = self else { return }
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files/\(fileID)?access_token=\(accessToken)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequestVoid(url: url, httpMethod: "DELETE", httpBody: nil, completion: completion)
                    print("Удаляю файл")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
}

extension GoogleRequest {
    func requestsGoogleCheckToken(completion: @escaping (Result<GoogleTokenInfo, NetworkError>) -> Void) {
        DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
            switch result {
            case .success(let accessToken):
                let urlString = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=" + accessToken
                guard let url = URL(string: urlString) else {
                    completion(.failure(.noData))
                    return
                }
                
                self.performRequest(url: url, httpMethod: "GET", httpBody: nil, completion: completion)
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
                
                self.performRequest(url: url, httpMethod: "POST", httpBody: httpBody, completion: completion)
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
                            print("Ошибка обновления токена: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                self.requestsGoogleUpdateToken { updateResult in
                    switch updateResult {
                    case .success(let newToken):
                        DatabaseService.shared.updateUserKeyFirebaseDatabase(nameStorage: .google, newAccessToken: newToken.access_token)
                        completion("Токен обновлен")
                        print("Токен отправлен в БД")
                    case .failure(let updateError):
                        print("Ошибка обновления токена: \(updateError.localizedDescription)")
                    }
                }
                print("Ошибка проверки токена: \(error.localizedDescription)")
            }
        }
    }
}

enum NetworkError: Error {
    case noData
    case tooManyRequests
    case decodingError
    case deleteError
}

func warningMessage(error: NetworkError) -> String {
    switch error {
    case .noData:
        return "Данные не найдены по этому URL"
    case .tooManyRequests:
        return "429: Слишком много запросов"
    case .decodingError:
        return "Ошибка декодирования данных"
    case .deleteError:
        return "Ошибка удаления файла"
    }
}
