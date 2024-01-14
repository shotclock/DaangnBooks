//
//  BookDetailTest.swift
//  DaangnBooksTests
//
//  Created by lee sangho on 1/15/24.
//

import XCTest
@testable import Networking
@testable import DaangnBooks

final class BookDetailTest: XCTestCase {
    func test_Error코드가_0이아닌경우_에러를반환하는지() async {
        let response = BookDetailResponse(error: "1", title: "", subtitle: "", authors: "", publisher: "", isbn10: "", isbn13: "", pages: "", year: "", rating: "", desc: "", price: "", image: "", url: "", pdf: nil)
        let repository = MockBookDetailRepository(response: .success(response))
        let useCase = DefaultBookDetailFetchUseCase(bookDetailRepository: repository)
        let result = await useCase.fetch(isbn13: "test")
        
        var isCorrectError = false
        if case .failure(let error) = result {
            if case .urlResponseError = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
    
    func test_ISBN값이_없을경우_에러를반환하는지() async {
        let repository = MockBookDetailRepository(response: .failure(.responseValidationFailure))
        let useCase = DefaultBookDetailFetchUseCase(bookDetailRepository: repository)
        
        let result = await useCase.fetch(isbn13: "")
        
        var isCorrectError = false
        if case .failure(let error) = result {
            if case .emptyISBN = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
    
    func test_디코딩을_실패할경우_올바른에러를_반환하는지() async {
        let mockData = "{\"error\":\"0\",\"total\":\"1\",\"page\":\"1\",\"books".data(using: .utf8)
        let networking = NetworkingBuilder.build(urlSession: MockURLSession.make(response: HTTPURLResponse(url: .init(string: "test")!,
                                                                                                           statusCode: 200,
                                                                                                           httpVersion: nil,
                                                                                                           headerFields: nil),
                                                                                 data: mockData))
        let repository = DefaultBookDetailRepository(networking: networking)
        
        let result = await repository.fetchData(isbn13: "test")
        
        var isCorrectError = false
        if case .failure(let error) = result {
            if case .responseValidationFailure = error {
                isCorrectError = true
            }
        }
        
        XCTAssertTrue(isCorrectError)
    }
    
    func test_디코딩을_성공할경우_데이터를_반환하는지() async {
        let rawJSON = """
{"error":"0","title":"Securing DevOps","subtitle":"Security in the Cloud","authors":"Julien Vehent","publisher":"Manning","language":"English","isbn10":"1617294136","isbn13":"9781617294136","pages":"384","year":"2018","rating":"4","desc":"An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team&#039;s highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your c...","price":"$39.65","image":"https://itbook.store/img/books/9781617294136.png","url":"https://itbook.store/books/9781617294136","pdf":{"Chapter 2":"https://itbook.store/files/9781617294136/chapter2.pdf","Chapter 5":"https://itbook.store/files/9781617294136/chapter5.pdf"}}
"""
        let mockData = rawJSON.data(using: .utf8)
        let networking = NetworkingBuilder.build(urlSession: MockURLSession.make(response: HTTPURLResponse(url: .init(string: "test")!,
                                                                                                           statusCode: 200,
                                                                                                           httpVersion: nil,
                                                                                                           headerFields: nil),
                                                                                 data: mockData))
        let repository = DefaultBookDetailRepository(networking: networking)
        
        let result = await repository.fetchData(isbn13: "test")
        
        var responseData: BookDetailResponse?
        if case .success(let data) = result {
            responseData = data
        }
        
        XCTAssertNotNil(responseData)
    }
}
