//
//  PerformRequest.swift
//  Disk
//
//  Created by Георгий on 05.09.2024.
//

import Foundation


protocol PerformRequest {
    
    func performRequest<T>(
        request: (@escaping (Result<T, NetworkError>) -> Void) -> Void,
        success: @escaping (T) -> Void,
        failure: @escaping (NetworkError) -> Void
    )
    
}

extension PerformRequest {
    func performRequest<T>(
        request: (@escaping (Result<T, NetworkError>) -> Void) -> Void,
        success: @escaping (T) -> Void,
        failure: @escaping (NetworkError) -> Void
    ) {
        request { result in
            switch result {
            case .success(let data):
                runOnMainThread {
                    success(data)
                }
            case .failure(let error):
                runOnMainThread {
                    failure(error)
                }
            }
        }
    }
    
    func runOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
