//
//  SearchBookRepository.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation
import Networking

protocol SearchBookRepository {
    func searchBook(by keyword: String, page: Int) async -> Result<SearchBookResponse, NetworkingError>
}

struct DefaultSearchBookRepository: SearchBookRepository {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func searchBook(by keyword: String, page: Int) async -> Result<SearchBookResponse, NetworkingError> {
        let apiResult = await networking.request(method: .get,
                                                 url: URLs.searchBook + keyword + "/\(page)",
                                                 parameter: nil)
        
        switch apiResult {
        case .success(let response):
            if let result = try? JSONDecoder().decode(SearchBookResponse.self, from: response) {
                return .success(result)
            }
            return .failure(.responseValidationFailure)
        case .failure(let error):
            return .failure(error)
        }
    }
}
