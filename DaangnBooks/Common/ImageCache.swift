//
//  ImageCache.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

final class ImageCache {
    static private var cacheStorage: [URL: Image] = [:]
    
    static func saveImage(url: URL,
                          image: Image) {
        cacheStorage[url] = image
    }
    
    static func getImage(from url: URL) -> Image? {
        cacheStorage[url]
    }
}
