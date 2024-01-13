//
//  NetworkError.swift
//
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

public enum NetworkError: LocalizedError {
    case urlError(error: URLError)
    case httpError(code: Int)
    case urlComponentFailure
    case responseValidationFailure
    case unspecified(description: String)
    
    public var errorDescription: String? {
        switch self {
        case .urlError(let error):
            return "URL ERROR: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTPERROR: \(code)"
        case .urlComponentFailure:
            return "urlComponent 구성 실패!"
        case .responseValidationFailure:
            return "응답값 검증 실패!"
        case .unspecified(let description):
            return description
        }
    }
}
