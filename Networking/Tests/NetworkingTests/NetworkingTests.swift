import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    override class func setUp() {
        
    }
    
    func test_NetworkingParameter가_Dictionary타입변환을_제대로하는지() {
        let parameter: NetworkingParameter = MockNetworkingParameter(stringValue: "test",
                                                                     intValue: 100)
        let dictionaryPrameter = parameter.toDictionary()
        let expectedResult = ["stringValue": "test", "intValue": 100] as [String : Any]
        
        XCTAssertEqual(NSDictionary(dictionary: dictionaryPrameter),
                       expectedResult as NSDictionary)
    }
    
    func test_HTTP응답코드가_500이면_에러를_받는지() async {
        let urlString = "https://api.itbook.store/1.0/search/mongodb"
        let session = MockURLSession.make(response: HTTPURLResponse(url: .init(string: urlString)!,
                                                                    statusCode: 500,
                                                                    httpVersion: nil,
                                                                    headerFields: nil))
        let mockNetworking = NetworkingBuilder.build(urlSession: session)
        
        let result = await mockNetworking.request(method: .get,
                                                  url: urlString,
                                                  parameter: nil,
                                                  timeoutInterval: 3)
        
        var networkError: NetworkingError?
        if case .failure(let error) = result {
            networkError = error
        }
        
        XCTAssertNotNil(networkError)
        XCTAssertEqual(networkError, .httpError(code: 500))
    }
    
    func test_URLError가_발생한경우_URLError를_반환하는가() async {
        let urlError = URLError(.badURL)
        let session = MockURLSession.make(error: urlError)
        let mockNetworking = NetworkingBuilder.build(urlSession: session)
        
        let result = await mockNetworking.request(method: .get,
                                                  url: "https://api.itbook.store/1.0/search/mongodb",
                                                  parameter: nil,
                                                  timeoutInterval: 3)
        
        var networkError: NetworkingError?
        var isErrorEqual = false
        if case .failure(let error) = result {
            networkError = error
        }
        
        if case .urlError(let error) = networkError {
            isErrorEqual = error.code == urlError.code
        }
        
        XCTAssertNotNil(networkError)
        XCTAssertTrue(isErrorEqual)
    }
    
    func test_HTTP응답코드가_200일때_제대로_데이터를_가져오는지() async {
        let urlString = "https://api.itbook.store/1.0/search/testesetsetset"
        let resultString = "{\"error\":\"0\",\"total\":\"0\",\"page\":\"1\",\"books\":[]}"
        let session = MockURLSession.make(response: HTTPURLResponse(url: .init(string: urlString)!,
                                                                    statusCode: 200,
                                                                    httpVersion: nil,
                                                                    headerFields: nil),
                                          data: resultString.data(using: .utf8))
        let mockNetworking = NetworkingBuilder.build(urlSession: session)
        
        let result = await mockNetworking.request(method: .get,
                                                  url: urlString,
                                                  parameter: nil,
                                                  timeoutInterval: 3)
        
        var resultData: Data?
        if case .success(let data) = result {
            resultData = data
        }
        
        XCTAssertEqual(resultData, resultString.data(using: .utf8))
    }
}
