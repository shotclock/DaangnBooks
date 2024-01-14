//
//  BookDetailRepository.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation
import Networking

protocol BookDetailRepository {
    func fetchData(isbn13: String) async -> Result<BookDetailResponse, NetworkingError>
}

struct DefaultBookDetailRepository: BookDetailRepository {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchData(isbn13: String) async -> Result<BookDetailResponse, NetworkingError> {
        let result = await networking.request(method: .get,
                                              url: URLs.detailBook + isbn13,
                                              parameter: nil,
                                              timeoutInterval: 3)
        
        switch result {
        case .success(let response):
            if let result = try? JSONDecoder().decode(BookDetailResponse.self, from: response) {
                return .success(result)
            }
            return .failure(.responseValidationFailure)
        case .failure(let error):
            return .failure(error)
        }
    }
}
