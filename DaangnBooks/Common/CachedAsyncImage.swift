//
//  CachedAsyncImage.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI
import Networking

struct CachedAsyncImage: View {
    private let url: URL
    @State private var image: UIImage?
    @Environment(\.imageCache) var imageCache
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        if let image = imageCache.getImage(from: url) {
            Image(uiImage: image)
                .resizable()
        } else {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ZStack {
                    Color.gray
                    ProgressView()
                }
                .task {
                    let loadedImage = await loadImage()
                    await MainActor.run {
                        self.image = loadedImage
                    }
                }
            }
        }
    }
    
    private func loadImage() async -> UIImage? {
        let result = await NetworkingBuilder.build().downloadData(url: url.absoluteString)
        
        if case .success(let successData) = result {
            imageCache.storeData(response: successData.1,
                                 data: successData.0,
                                 url: url.absoluteString)
            return .init(data: successData.0)
        }
        
        return .init(systemName: Images.Strings.exclamationmarkWithTriangle)
    }
}

#Preview {
    CachedAsyncImage(url: .init(string: URLs.searchBook)!)
}
