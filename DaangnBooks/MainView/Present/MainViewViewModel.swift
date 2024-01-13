//
//  MainViewViewModel.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

@Observable
final class MainViewViewModel {
    var bookData: [BookSearchInfo] = []
    private let searchBookUseCase: SearchBookUseCase
    
    init(searchBookUseCase: SearchBookUseCase) {
        self.searchBookUseCase = searchBookUseCase
    }
    
    func didOnSubmitTextField(text: String) {
        Task {
            switch await searchBookUseCase.search(keyword: text) {
            case .success(let data):
                await MainActor.run {
                    bookData = data
                }
            case .failure(let error):
                print("에러 발생! \(error)")
            }
        }
    }
}
