
import Foundation
import UIKit

protocol GoogleDriveRequest: NetworkRequest, TokenService {
    func requestsAllFile(nameStorage: NameStorage, completion: @escaping (Result<[Files], NetworkError>) -> Void)
    func requestsGoogleFolderFile(idFile: String, completion: @escaping (Result<[GoogleFile], NetworkError>) -> Void)
    func requestsGoogleAbout(completion: @escaping (Result<UserAbout, NetworkError>) -> Void)
    func requestsGoogleOneFile(fileID: String, completion: @escaping (Result<GoogleFile, NetworkError>) -> Void)
    func requestsUpdateNameGoogleFile(fileID: String, newName: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func requestsDeleteGoogleFile(fileID: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

extension GoogleDriveRequest {
    func requestsAllFile(nameStorage: NameStorage, completion: @escaping (Result<[Files], NetworkError>) -> Void) {
        googleCheckAndUpdateToken { _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    var urlComponents = URLComponents(string: "https://www.googleapis.com/drive/v3/files")
                    urlComponents?.queryItems = [
                        URLQueryItem(name: "q", value: "'root' in parents and mimeType!='application/vnd.google-apps.shortcut'"),
                        URLQueryItem(name: "fields", value: "nextPageToken,files(id,name,mimeType,size,thumbnailLink,iconLink,modifiedTime,viewedByMeTime,webContentLink)")
                    ]
                    
                    guard let url = urlComponents?.url else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, httpBody: nil) { (result: Result<GoogleStructeFileList, NetworkError>) in
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
        googleCheckAndUpdateToken { _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    var urlComponents = URLComponents(string: "https://www.googleapis.com/drive/v3/files")
                                       urlComponents?.queryItems = [
                                           URLQueryItem(name: "q", value: "\"\(idFile)\" in parents"),
                                           URLQueryItem(name: "fields", value: "files(*)")
                                       ]
                                       
                                       guard let url = urlComponents?.url else {
                                           completion(.failure(.noData))
                                           return
                                       }
                    
                    self.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, httpBody: nil) { (result: Result<GoogleStructeFileList, NetworkError>) in
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
        googleCheckAndUpdateToken {  _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    var urlComponents = URLComponents(string: "https://www.googleapis.com/drive/v3/about")
                                        urlComponents?.queryItems = [
                                            URLQueryItem(name: "fields", value: "*")
                                        ]
                                        
                                        guard let url = urlComponents?.url else {
                                            completion(.failure(.noData))
                                            return
                                        }
                    
                    self.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, httpBody: nil, completion: completion)
                    print("Получил данные профиля")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }

    func requestsGoogleOneFile(fileID: String, completion: @escaping (Result<GoogleFile, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    var urlComponents = URLComponents(string: "https://www.googleapis.com/drive/v3/files/\(fileID)")
                    urlComponents?.queryItems = [
                        URLQueryItem(name: "fields", value: "id,name,size,mimeType,thumbnailLink,modifiedTime,iconLink,webContentLink")
                    ]
                    
                    guard let url = urlComponents?.url else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, httpBody: nil) { (result: Result<GoogleFile, NetworkError>) in
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
        googleCheckAndUpdateToken { _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files/\(fileID)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    let httpBody = try? JSONSerialization.data(withJSONObject: ["name": newName], options: [])
                    
                    self.performRequestVoid(url: url, httpMethod: "PATCH", accessToken: accessToken, httpBody: httpBody, completion: completion)
                    print("Обновляю имя файла")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    func requestsDeleteGoogleFile(fileID: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        googleCheckAndUpdateToken { _ in
            DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                switch result {
                case .success(let accessToken):
                    let urlString = "https://www.googleapis.com/drive/v3/files/\(fileID)"
                    guard let url = URL(string: urlString) else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    self.performRequestVoid(url: url, httpMethod: "DELETE", accessToken: accessToken, httpBody: nil, completion: completion)
                    print("Удаляю файл")
                case .failure(let error):
                    print("Ошибка базы данных: \(error.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        }
    }
}
