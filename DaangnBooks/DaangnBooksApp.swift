//
//  DaangnBooksApp.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import SwiftUI

@main
struct DaangnBooksApp: App {
    private let imageCache = ImageCache(cache: .init(memoryCapacity: 50 * 1024 * 1024,
                                                     diskCapacity: 100 * 1024 * 1024))
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewDependencyContainer().resolveMainViewViewModel())
        }
        .environment(\.imageCache, imageCache)
    }
}
