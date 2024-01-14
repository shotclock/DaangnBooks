//
//  SearchBookMocks.swift
//  DaangnBooksTests
//
//  Created by lee sangho on 1/14/24.
//

import XCTest
@testable import DaangnBooks
@testable import Networking

struct MockSearchBookRepository: SearchBookRepository {
    private var response: Result<DaangnBooks.SearchBookResponse, NetworkingError>
    
    init(response: Result<DaangnBooks.SearchBookResponse, NetworkingError>) {
        self.response = response
    }
    
    func searchBook(by keyword: String, page: Int) async -> Result<DaangnBooks.SearchBookResponse, NetworkingError> {
        return response
    }
}

class MockURLProtocol: URLProtocol {
    static var mockResponse: URLResponse?
    static var urlError: Error?
    static var data: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.urlError {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let response = MockURLProtocol.mockResponse {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = MockURLProtocol.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

class MockURLSession {
    static func make(response: URLResponse? = nil, error: Error? = nil, data: Data? = nil) -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        MockURLProtocol.mockResponse = response
        MockURLProtocol.urlError = error
        MockURLProtocol.data = data
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        
        return .init(configuration: sessionConfiguration)
    }
}
