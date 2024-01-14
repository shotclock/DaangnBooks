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
    case emptyList
    case network(error: NetworkingError)
    
    var errorDescription: String? {
        switch self {
        case .emptyList:
            return "먼저 검색한 후 다음 데이터를 불러올 수 있습니다."
        case .emptyKeyword:
            return "검색어를 입력해주세요!"
        case .network(let error):
            return error.errorDescription
        }
    }
}
