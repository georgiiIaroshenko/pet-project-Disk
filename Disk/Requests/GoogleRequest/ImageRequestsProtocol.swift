
import Foundation
import UIKit

protocol ImageRequestProtocol: TokenService {
    func universalGetImage(stringURL: String) async throws -> Data
    func getImageGoogleDrive(fileID: String) async throws -> Data
}

extension ImageRequestProtocol {
    
    func universalGetImage(stringURL: String) async throws -> Data {
        guard let url = URL(string: stringURL) else {
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Ошибка: некорректный URL"])
        }
        
        return try await performImageRequest(url: url)
    }
    
    func getImageGoogleDrive(fileID: String) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            googleCheckAndUpdateToken { _ in
                DatabaseService.shared.getToken(nameStorage: .google, tokenType: .accessToken) { result in
                    switch result {
                    case .success(let accessToken):
                        let fileURLString = "https://www.googleapis.com/drive/v3/files/\(fileID)?alt=media"
                        guard let finalURL = URL(string: fileURLString) else {
                            continuation.resume(throwing: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Ошибка: некорректный URL"]))
                            return
                        }
                        
                        var request = URLRequest(url: finalURL)
                        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                        let requestCopy = request
                        
                        Task {
                            do {
                                let data = try await self.performImageRequest(urlRequest: requestCopy)
                                continuation.resume(returning: data)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    // Выполняем запрос по URL и возвращаем данные изображения
    private func performImageRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response: response, data: data)
        return data
    }

    // Выполняем запрос с использованием URLRequest
    private func performImageRequest(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try validateResponse(response: response, data: data)
        return data
    }

    // Проверка ответа от сервера и данных
    private func validateResponse(response: URLResponse?, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Ошибка: некорректный ответ от сервера"])
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Ошибка: сервер вернул статус \(httpResponse.statusCode)"])
        }
        
        guard let mimeType = response?.mimeType, mimeType.hasPrefix("image") else {
            throw URLError(.cannotDecodeContentData, userInfo: [NSLocalizedDescriptionKey: "Ошибка: ответ не является изображением"])
        }
    }
}

