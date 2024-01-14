//
//  BookDetailFetchError.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation
import Networking

enum BookDetailFetchError: LocalizedError {
    case urlResponseError
    case networkError(error: NetworkingError)
}
