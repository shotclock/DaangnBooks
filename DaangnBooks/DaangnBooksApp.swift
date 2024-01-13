//
//  DaangnBooksApp.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import SwiftUI

@main
struct DaangnBooksApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewDependencyContainer().resolveMainViewViewModel())
        }
    }
}
