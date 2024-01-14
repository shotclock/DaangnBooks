//
//  EnvironmentValues+Extension.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheEnvironmentValue.self] }
        set { self[ImageCacheEnvironmentValue.self] = newValue }
    }
}
