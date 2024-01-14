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
    
    func test_디코딩을_성공할경우_데이터를_반환하는지() async {
        let rawJSON = """
{"error":"0","total":"80","page":"1","books":[{"title":"MongoDB in Action, 2nd Edition","subtitle":"Covers MongoDB version 3.0","isbn13":"9781617291609","price":"$19.99","image":"https://itbook.store/img/books/9781617291609.png","url":"https://itbook.store/books/9781617291609"},{"title":"MongoDB and Python","subtitle":"Patterns and processes for the popular document-oriented database","isbn13":"9781449310370","price":"$6.88","image":"https://itbook.store/img/books/9781449310370.png","url":"https://itbook.store/books/9781449310370"},{"title":"Building Node Applications with MongoDB and Backbone","subtitle":"Rapid Prototyping and Scalable Deployment","isbn13":"9781449337391","price":"$4.85","image":"https://itbook.store/img/books/9781449337391.png","url":"https://itbook.store/books/9781449337391"},{"title":"Practical MongoDB","subtitle":"Architecting, Developing, and Administering MongoDB","isbn13":"9781484206485","price":"$41.65","image":"https://itbook.store/img/books/9781484206485.png","url":"https://itbook.store/books/9781484206485"},{"title":"The Definitive Guide to MongoDB, 3rd Edition","subtitle":"A complete guide to dealing with Big Data using MongoDB","isbn13":"9781484211830","price":"$49.99","image":"https://itbook.store/img/books/9781484211830.png","url":"https://itbook.store/books/9781484211830"},{"title":"MongoDB Performance Tuning","subtitle":"Optimizing MongoDB Databases and their Applications","isbn13":"9781484268780","price":"$34.74","image":"https://itbook.store/img/books/9781484268780.png","url":"https://itbook.store/books/9781484268780"},{"title":"Pentaho Analytics for MongoDB","subtitle":"Combine Pentaho Analytics and MongoDB to create powerful analysis and reporting solutions","isbn13":"9781782168355","price":"$16.99","image":"https://itbook.store/img/books/9781782168355.png","url":"https://itbook.store/books/9781782168355"},{"title":"Pentaho Analytics for MongoDB Cookbook","subtitle":"Over 50 recipes to learn how to use Pentaho Analytics and MongoDB to create powerful analysis and reporting solutions","isbn13":"9781783553273","price":"$44.99","image":"https://itbook.store/img/books/9781783553273.png","url":"https://itbook.store/books/9781783553273"},{"title":"Web Development with MongoDB and NodeJS, 2nd Edition","subtitle":"Build an interactive and full-featured web application from scratch using Node.js and MongoDB","isbn13":"9781785287527","price":"$39.99","image":"https://itbook.store/img/books/9781785287527.png","url":"https://itbook.store/books/9781785287527"},{"title":"MongoDB Cookbook, 2nd Edition","subtitle":"Harness the latest features of MongoDB 3 with this collection of 80 recipes - from managing cloud platforms to app development, this book is a vital resource","isbn13":"9781785289989","price":"$44.99","image":"https://itbook.store/img/books/9781785289989.png","url":"https://itbook.store/books/9781785289989"}]}
"""
        let mockData = rawJSON.data(using: .utf8)
        let networking = NetworkingBuilder.build(urlSession: MockURLSession.make(response: HTTPURLResponse(url: .init(string: "test")!,
                                                                                                           statusCode: 200,
                                                                                                           httpVersion: nil,
                                                                                                           headerFields: nil),
                                                                                 data: mockData))
        let repository = DefaultSearchBookRepository(networking: networking)
        
        let result = await repository.searchBook(by: "test", page: 1)
        
        var responseData: SearchBookResponse?
        if case .success(let data) = result {
            responseData = data
        }
        
        XCTAssertNotNil(responseData)
    }
}
