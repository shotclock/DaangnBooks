//
//  ImageCache.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

final class ImageCache {
    private var cache: URLCache
    
    init(cache: URLCache) {
        self.cache = cache
    }
    
    func storeData(response: URLResponse, data: Data, url: String) {
        if let url = URL(string: url) {
            cache.storeCachedResponse(.init(response: response,
                                            data: data),
                                      for: .init(url: url))
        }
    }
    
    func getImage(from url: URL) -> UIImage? {
        let cachedResponse = cache.cachedResponse(for: .init(url: url))
        if let data = cachedResponse?.data {
            return .init(data: data)
        }
        return nil
    }
}
