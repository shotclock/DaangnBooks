//
//  SearchBookTest.swift
//  DaangnBooksTests
//
//  Created by lee sangho on 1/14/24.
//

import XCTest
@testable import DaangnBooks
@testable import Networking

final class SearchBookTest: XCTestCase {
    private var searchBookUseCase: SearchBookUseCase!
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        searchBookUseCase = nil
    }
    
    func test_검색어가_없을경우에_에러를_반환하는지() async {
        let response = SearchBookResponse(total: "100", books: [.init(title: "", subtitle: "", isbn13: "123", image: "", url: ""),
                                                                .init(title: "", subtitle: "", isbn13: "123", image: "", url: "")])
        
        searchBookUseCase = DefaultSearchBookUseCase(searchBookRepository: MockSearchBookRepository(response: .success(response)))
        let searchKeyword = ""
        let searchResult = await searchBookUseCase.search(keyword: searchKeyword)
        
        var isCorrectError = false
        
        if case .failure(let error) = searchResult {
            if case .emptyKeyword = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
    
    func test_total보다_주어진리스트가_적을경우에_hasMoreList가_true인지() async {
        let response = SearchBookResponse(total: "100", books: [.init(title: "", subtitle: "", isbn13: "123", image: "", url: ""),
                                                                .init(title: "", subtitle: "", isbn13: "123", image: "", url: "")])
        
        searchBookUseCase = DefaultSearchBookUseCase(searchBookRepository: MockSearchBookRepository(response: .success(response)))
        let searchKeyword = "test"
        let searchResult = await searchBookUseCase.search(keyword: searchKeyword)
        
        var hasMoreList = false
        if case .success(let data) = searchResult {
            hasMoreList = data.hasMoreList
        }
        
        XCTAssertTrue(hasMoreList)
    }
    
    func test_loadMoreList를_이용해서_정상적인_응답을_받은경우_리스트에_추가되는지() async {
        let response = SearchBookResponse(total: "100", books: [.init(title: "", subtitle: "", isbn13: "123", image: "", url: ""),
                                                                .init(title: "", subtitle: "", isbn13: "456", image: "", url: "")])
        
        searchBookUseCase = DefaultSearchBookUseCase(searchBookRepository: MockSearchBookRepository(response: .success(response)))
        let searchKeyword = "test"
        let _ = await searchBookUseCase.search(keyword: searchKeyword)
        
        var list = [SearchBookInfo]()
        let loadMoreListResult = await searchBookUseCase.loadMoreList()
        if case .success(let data) = loadMoreListResult {
            list = data.list
        }
        
        XCTAssertEqual(list, [SearchBookInfo(title: "", subtitle: "", isbn13: "123", image: "", url: ""),
                              SearchBookInfo(title: "", subtitle: "", isbn13: "456", image: "", url: ""),
                              SearchBookInfo(title: "", subtitle: "", isbn13: "123", image: "", url: ""),
                              SearchBookInfo(title: "", subtitle: "", isbn13: "456", image: "", url: "")])
    }
    
    func test_디코딩을_실패할경우_올바른에러를_반환하는지() async {
        let mockData = "{\"error\":\"0\",\"total\":\"1\",\"page\":\"1\",\"books".data(using: .utf8)
        let networking = NetworkingBuilder.build(urlSession: MockURLSession.make(response: HTTPURLResponse(url: .init(string: "test")!,
                                                                                                           statusCode: 200,
                                                                                                           httpVersion: nil,
                                                                                                           headerFields: nil),
                                                                                 data: mockData))
        let repository = DefaultSearchBookRepository(networking: networking)
        
        let result = await repository.searchBook(by: "test", page: 1)
        
        var isCorrectError = false
        if case .failure(let error) = result {
            if case .responseValidationFailure = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
    
    func test_리스트가_없는경우에_loadMoreList를_호출하면_에러가_발생하는지() async {
        let useCase = DefaultSearchBookUseCase(searchBookRepository: MockSearchBookRepository(response: .failure(.urlComponentFailure)))
        
        let result = await useCase.loadMoreList()
        
        var isCorrectError = false
        if case .failure(let error) = result {
            if case .emptyList = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
}
