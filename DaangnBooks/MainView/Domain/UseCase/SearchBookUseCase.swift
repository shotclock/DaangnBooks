//
//  SearchBookUseCase.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation
import Networking

protocol SearchBookUseCase {
    func search(keyword: String) async -> Result<[BookSearchInfo], NetworkingError>
}

struct DefaultSearchBookUseCase: SearchBookUseCase {
    private let searchBookRepository: SearchBookRepository
    
    init(searchBookRepository: SearchBookRepository) {
        self.searchBookRepository = searchBookRepository
    }
    
    func search(keyword: String) async -> Result<[BookSearchInfo], NetworkingError> {
        let result = await searchBookRepository.searchBook(by: keyword)
        
        switch result {
        case .success(let data):
            return .success(data.books)
        case .failure(let error):
            return .failure(error)
        }
    }
}
