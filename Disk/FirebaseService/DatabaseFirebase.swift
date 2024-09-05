//
import Foundation
import FirebaseFirestore

class DatabaseService {
    
    static let shared = DatabaseService()
    private let dataBase = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return dataBase.collection("users")
    }
    
    private var representationRef: CollectionReference {
        guard let userId = AuthFirebase.shared.currentUser?.uid else {
            fatalError("User not authenticated")
        }
        return dataBase.collection("users").document(userId).collection("Repositories")
    }
    
    private init() {}
    
    func setUser(nameStorage: NameStorage, user: GoogleUserStruct, completion: @escaping (Result<GoogleUserStruct, Error>) -> ()){
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.setRepositories(to: nameStorage.rawValue, user: user , storage: user.repositories) { result in
                    switch result {
                    case .success(let storage):
                        completion(.success(user))
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func setRepositories(to nameStorage: NameStorage.RawValue, user: GoogleUserStruct, storage: Storage, completion: @escaping (Result<Storage, Error>) -> ()) {
        let repositoriesRef = usersRef.document(user.id).collection("Repositories")
        repositoriesRef.document(storage.nameStorage).setData(storage.representation)
        completion(.success(storage))
    }
    
    func updateUserKeyFirebaseDatabase(nameStorage: NameStorage, newAccessToken: String) {
        switch nameStorage {
        case .google:
            representationRef.document(nameStorage.rawValue).updateData(["accessToken" : newAccessToken])
        case .yandex:
            print("Временно не доступно")
        case .apple:
            print("Временно не доступно")
        }
    }
    
    func getUser(nameStorage: NameStorage, completion: @escaping (Result<Storage, Error>) -> ()) {
        fetchDocument(nameStorage: nameStorage, documentName: nameStorage.rawValue) { result in
            switch result {
            case .success(let data):
                guard let refreshToken = data["refreshToken"] as? String,
                      let accessToken = data["accessToken"] as? String,
                      let idAccessToken = data["idAccessToken"] as? String else {
                    completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing fields in document."])))
                    return
                }
                let user = Storage(nameStorage: nameStorage.rawValue, accessToken: accessToken, refreshToken: refreshToken, idAccessToken: idAccessToken)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getToken(nameStorage: NameStorage, tokenType: NameToken, completion: @escaping (Result<String, Error>) -> ()) {
        fetchDocument(nameStorage: nameStorage, documentName: nameStorage.rawValue) { result in
            switch result {
            case .success(let data):
                guard let token = data[tokenType.rawValue] as? String else {
                    completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing \(tokenType.rawValue) in document."])))
                    return
                }
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchDocument(nameStorage: NameStorage, documentName: String, completion: @escaping (Result<[String: Any], Error>) -> ()) {
        representationRef.document(documentName).getDocument { docSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snap = docSnapshot, let data = snap.data() else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document snapshot or data is nil."])))
                return
            }
            completion(.success(data))
        }
    }
}

enum NameStorage: String {
    case google = "Google"
    case yandex = "Yandex"
    case apple = "Apple"
}

enum NameToken: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}
