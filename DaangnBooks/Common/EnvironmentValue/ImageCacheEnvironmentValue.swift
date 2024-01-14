//
//  ImageCacheEnvironmentValue.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

struct ImageCacheEnvironmentValue: EnvironmentKey {
    static var defaultValue: ImageCache {
        .init(cache: .shared)
    }
}
