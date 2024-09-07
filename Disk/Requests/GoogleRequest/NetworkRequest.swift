
import Foundation

protocol NetworkRequest {
    func performRequest<T: Decodable>(url: URL, httpMethod: String, accessToken: String, httpBody: Data?, completion: @escaping (Result<T, NetworkError>) -> Void)
    func performRequestVoid(url: URL, httpMethod: String, accessToken: String, httpBody: Data?, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

extension NetworkRequest {
    func performRequest<T: Decodable>(url: URL, httpMethod: String, accessToken: String, httpBody: Data?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        if httpBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

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

    func performRequestVoid(url: URL, httpMethod: String, accessToken: String, httpBody: Data?, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        if httpBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

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
