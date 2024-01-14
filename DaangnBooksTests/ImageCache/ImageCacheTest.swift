//
//  ImageCacheTest.swift
//  DaangnBooksTests
//
//  Created by lee sangho on 1/14/24.
//

import XCTest
@testable import DaangnBooks

final class ImageCacheTest: XCTestCase {

    var imageCache: ImageCache!
    var urlCache: URLCache!
    
    override func setUp() {
        urlCache = .init(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024)
        imageCache = .init(cache: urlCache)
    }
    
    override func tearDown() {
        urlCache.removeAllCachedResponses()
        imageCache = nil
    }
    
    func test_이미지가_제대로_저장되는지() {
        let url = "https://itbook.store/img/books/9781484206485.png"
        let response = HTTPURLResponse(url: .init(string: url)!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        let data = UIImage(systemName: Images.Strings.exclamationmark)?.pngData()
        
        imageCache.storeData(response: response!,
                             data: data!,
                             url: url)
        
        let savedRespsonse = urlCache.cachedResponse(for: .init(url: .init(string: url)!))
        
        XCTAssertNotNil(savedRespsonse)
        XCTAssertEqual(savedRespsonse?.data, data)
    }
    
    func test_저장된_이미지가_불러와지는지() {
        let url = "https://itbook.store/img/books/9781484206485.png"
        let response = HTTPURLResponse(url: .init(string: url)!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        let data = UIImage(systemName: Images.Strings.exclamationmark)?.pngData()
        
        imageCache.storeData(response: response!,
                             data: data!,
                             url: url)
        
        let image = imageCache.getImage(from: .init(string: url)!)
        XCTAssertNotNil(image)
    }
    
    func test_이미지가_없을경우에_nil을_반환하는지() {
        let url = "https://itbook.store/img/books/9781484206485.png"
        let image = imageCache.getImage(from: .init(string: url)!)
        
        XCTAssertNil(image)
    }
}
