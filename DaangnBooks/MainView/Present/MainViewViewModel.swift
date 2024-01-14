//
//  MainViewViewModel.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

@Observable
final class MainViewViewModel {
    var bookData: [SearchBookInfo]?
    var errorDescription: String?
    var isLoadingContent: Bool
    private let searchBookUseCase: SearchBookUseCase
    
    init(searchBookUseCase: SearchBookUseCase) {
        self.searchBookUseCase = searchBookUseCase
        isLoadingContent = false
    }
    
    func didOnSubmitTextField(text: String) {
        errorDescription = nil
        bookData = nil
        isLoadingContent = true
        
        Task {
            switch await searchBookUseCase.search(keyword: text) {
            case .success(let data):
                await MainActor.run {
                    bookData = data
                }
            case .failure(let error):
                if let description = error.errorDescription {
                    await MainActor.run {
                        errorDescription = description
                    }
                }
            }
            isLoadingContent = false
        }
    }
}
