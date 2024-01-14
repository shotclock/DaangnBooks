//
//  SearchBookError.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import Foundation
import Networking

enum SearchBookError: LocalizedError {
    case emptyKeyword
    case network(error: NetworkingError)
    
    var errorDescription: String? {
        switch self {
        case .emptyKeyword:
            return "검색어를 입력해주세요!"
        case .network(let error):
            return error.errorDescription
        }
    }
}
