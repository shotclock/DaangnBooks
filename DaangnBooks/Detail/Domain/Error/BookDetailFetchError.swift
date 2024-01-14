//
//  BookDetailFetchError.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation
import Networking

enum BookDetailFetchError: LocalizedError {
    case emptyISBN
    case urlResponseError
    case networkError(error: NetworkingError)
    
    var errorDescription: String? {
        switch self {
        case .emptyISBN:
            return "isbn 값이 없습니다!!"
        case .urlResponseError:
            return "API 에러!!"
        case .networkError(let error):
            return error.errorDescription
        }
    }
}
