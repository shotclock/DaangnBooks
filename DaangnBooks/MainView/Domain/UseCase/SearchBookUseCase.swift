//
//  SearchBookUseCase.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation
import Networking

protocol SearchBookUseCase {
    func search(keyword: String) async -> Result<SearchBookResult, SearchBookError>
    func loadMoreList() async -> Result<SearchBookResult, SearchBookError>
}

final class DefaultSearchBookUseCase: SearchBookUseCase {
    private var page: Int
    private var list: [SearchBookInfo]
    private var keyword: String
    private let searchBookRepository: SearchBookRepository
    
    init(searchBookRepository: SearchBookRepository) {
        page = 1
        list = []
        keyword = ""
        self.searchBookRepository = searchBookRepository
    }
    
    func search(keyword: String) async -> Result<SearchBookResult, SearchBookError> {
        guard !keyword.isEmpty else {
            return .failure(.emptyKeyword)
        }
        
        reset()
        self.keyword = keyword
        
        let result = await searchBookRepository.searchBook(by: keyword,
                                                           page: page)
        
        switch result {
        case .success(let data):
            let hasMoreList = (Int(data.total) ?? .zero) > data.books.count
            list = data.books
            
            return .success(.init(hasMoreList: hasMoreList,
                                  list: data.books))
        case .failure(let error):
            return .failure(.network(error: error))
        }
    }
    
    func loadMoreList() async -> Result<SearchBookResult, SearchBookError> {
        guard !list.isEmpty else {
            return .failure(.emptyList)
        }
        
        page += 1
        let result = await searchBookRepository.searchBook(by: keyword,
                                                           page: page)
        
        switch result {
        case .success(let data):
            list.append(contentsOf: data.books)
            let hasMoreList = (Int(data.total) ?? .zero) > list.count
            return .success(.init(hasMoreList: hasMoreList,
                                  list: list))
        case .failure(let error):
            return .failure(.network(error: error))
        }
    }
    
    private func reset() {
        page = 1
        list = []
        keyword = ""
    }
}
