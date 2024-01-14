//
//  BookDetailMocks.swift
//  DaangnBooksTests
//
//  Created by lee sangho on 1/15/24.
//

import XCTest
@testable import DaangnBooks
@testable import Networking

struct MockBookDetailRepository: BookDetailRepository {
    private var response: Result<BookDetailResponse, NetworkingError>
    
    init(response: Result<BookDetailResponse, NetworkingError>) {
        self.response = response
    }
    
    func fetchData(isbn13: String) async -> Result<BookDetailResponse, NetworkingError> {
        return response
    }
}

