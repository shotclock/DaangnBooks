//
//  CachedAsyncImage.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        if let image = ImageCache.getImage(from: url) {
            image
                .resizable()
        } else {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    let _ = ImageCache.saveImage(url: url,
                                                 image: image)
                }
                phase
                    .image?
                    .resizable()
            }
        }
    }
}

#Preview {
    CachedAsyncImage(url: .init(string: URLs.searchBook)!)
}

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
