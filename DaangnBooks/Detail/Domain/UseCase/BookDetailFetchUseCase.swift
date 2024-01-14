//
//  BookDetailFetchUseCase.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation

protocol BookDetailFetchUseCase {
    func fetch(isbn13: String) async -> Result<DetailBookInfo, BookDetailFetchError>
}

struct DefaultBookDetailFetchUseCase: BookDetailFetchUseCase {
    private let bookDetailRepository: BookDetailRepository
    
    init(bookDetailRepository: BookDetailRepository) {
        self.bookDetailRepository = bookDetailRepository
    }
    
    func fetch(isbn13: String) async -> Result<DetailBookInfo, BookDetailFetchError> {
        let result = await bookDetailRepository.fetchData(isbn13: isbn13)
        
        switch result {
        case .success(let response):
            if response.error == "0" {
                return .success(response.toDomain())
            }
            return .failure(.urlResponseError)
        case .failure(let error):
            return .failure(.networkError(error: error))
        }
    }
}
