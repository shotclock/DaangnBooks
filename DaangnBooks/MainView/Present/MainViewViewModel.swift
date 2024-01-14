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
    var hasMoreList: Bool
    
    private let searchBookUseCase: SearchBookUseCase
    
    init(searchBookUseCase: SearchBookUseCase) {
        self.searchBookUseCase = searchBookUseCase
        isLoadingContent = false
        hasMoreList = false
    }
    
    func didOnSubmitTextField(text: String) {
        errorDescription = nil
        bookData = nil
        isLoadingContent = true
        hasMoreList = false
        
        Task {
            switch await searchBookUseCase.search(keyword: text) {
            case .success(let data):
                await handleSearchSuccess(data: data)
            case .failure(let error):
                await handleSearchFailure(error: error)
            }
            isLoadingContent = false
        }
    }
    
    func loadMoreData() {
        Task {
            switch await searchBookUseCase.loadMoreList() {
            case .success(let data):
                await handleSearchSuccess(data: data)
            case .failure(let error):
                await handleSearchFailure(error: error)
            }
        }
    }
    
    @MainActor
    private func handleSearchSuccess(data: SearchBookResult) {
        bookData = data.list
        hasMoreList = data.hasMoreList
    }
    
    @MainActor
    private func handleSearchFailure(error: SearchBookError) {
        if let description = error.errorDescription {
            errorDescription = description
        }
    }
}
