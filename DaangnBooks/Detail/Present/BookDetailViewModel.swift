//
//  BookDetailViewModel.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation

@Observable
final class BookDetailViewModel {
    var detailInfo: DetailBookInfo?
    var errorDescription: String?
    private let bookDetailFetchUseCase: BookDetailFetchUseCase
    
    init(bookDetailFetchUseCase: BookDetailFetchUseCase) {
        self.bookDetailFetchUseCase = bookDetailFetchUseCase
    }
    
    func fetchDetailInfo(isbn13: String) {
        errorDescription = nil
        detailInfo = nil
        
        Task {
            let result = await bookDetailFetchUseCase.fetch(isbn13: isbn13)
            
            switch result {
            case .success(let data):
                detailInfo = data
            case .failure(let error):
                errorDescription = error.errorDescription
            }
        }
    }
}
